# syntax=docker/dockerfile:1.7

ARG RUBY_VERSION=3.4-slim-bookworm
ARG NODE_VERSION=22

# ---- base ----------------------------------------------------------------
FROM ruby:${RUBY_VERSION} AS base

ENV LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    PATH=/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

WORKDIR /rails

# ---- builder -------------------------------------------------------------
FROM base AS builder

ARG NODE_VERSION

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential libpq-dev libyaml-dev pkg-config \
      git curl ca-certificates \
 && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3 \
 && rm -rf "$BUNDLE_PATH"/ruby/*/cache "$BUNDLE_PATH"/ruby/*/bundler/gems/*/.git

COPY package.json package-lock.json ./
RUN npm ci --include=dev

COPY . .

# Pre-build assets (Vite manifest into public/vite). Skip if no env at build time.
ENV SECRET_KEY_BASE=dummy
RUN bundle exec rails assets:precompile || true

# ---- runtime -------------------------------------------------------------
FROM base AS runtime

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libpq5 libyaml-0-2 ca-certificates curl \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd --system --gid 1001 rails \
 && useradd  --system --uid 1001 --gid 1001 --create-home --shell /bin/bash rails

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=rails:rails /rails /rails

USER rails

EXPOSE 3000

ENV RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
