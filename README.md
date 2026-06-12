# rails-inertia-react

A production-shaped Rails 8 starter wired to Inertia + React (TypeScript) on the page side, with Postgres, Redis, MinIO (S3), Sidekiq (web + cron), Tailwind v4 + DaisyUI, CanCanCan, RSpec + FactoryBot — all behind a single `docker compose up`.

## Stack

- **Rails 8.0** + Puma
- **Postgres 17**, **Redis 7**, **MinIO** (S3-compatible)
- **Sidekiq 7** + **sidekiq-cron** (heartbeat job runs every minute)
- **Inertia** (`inertia_rails` + `@inertiajs/react`) → React 19 + TypeScript on the page
- **Vite** via `vite_rails` with HMR (port 3036)
- **Tailwind v4** + **DaisyUI v5**
- **CanCanCan** (`Ability` placeholder)
- **RSpec** + **FactoryBot** + **shoulda-matchers**

## Run

```sh
cp .env.example .env
docker compose up --build
```

Open:

- App → http://localhost:3000
- Sidekiq Web → http://localhost:3000/sidekiq (login `SIDEKIQ_USER` / `SIDEKIQ_PASSWORD`)
- MinIO console → http://localhost:9001 (`minioadmin` / `minioadmin`)

The first boot creates the database, runs migrations, creates the MinIO bucket, then starts Rails + Sidekiq + Vite.

## Tests

```sh
docker compose run --rm web bundle exec rspec
```

## Layout

```
app/
  controllers/     # rails controllers
  frontend/        # vite-rails source
    entrypoints/application.tsx   # Inertia React bootstrap
    pages/Home.tsx                # one Inertia page per file
    styles/application.css        # tailwind + daisyui imports
  jobs/            # ActiveJob + sidekiq jobs (HeartbeatJob)
  models/          # AR models, Ability, User
config/
  routes.rb
  sidekiq.yml
  sidekiq_cron.yml
  storage.yml      # MinIO via S3 protocol, env-driven
  database.yml     # env-driven
docker-compose.yml
Dockerfile         # production multi-stage
Dockerfile.dev     # development image used by compose
```

## Customizing

- **Add a page**: drop a `.tsx` file in `app/frontend/pages/`, render with `render inertia: 'YourPage', props: {...}` from a controller.
- **Background job**: subclass `ApplicationJob` (uses `:sidekiq` adapter), enqueue with `MyJob.perform_later`.
- **Cron**: add to `config/sidekiq_cron.yml`.
- **Authorization**: edit `app/models/ability.rb`, then call `authorize! :read, @resource` in controllers.
- **Override host ports**: see `.env.example`. Defaults avoid the most common collisions (Postgres on 5434, Redis on 6380).

## Production image

```sh
docker build -t rails-inertia-react:prod .
```

The `Dockerfile` is a multi-stage prod image: separate builder stage compiles assets and installs gems, runtime stage strips toolchain and runs as `rails:rails`.
