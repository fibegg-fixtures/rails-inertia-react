source "https://rubygems.org"

gem "rails", "~> 8.0.5"
gem "propshaft"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"

# Frontend: Vite + Inertia (React on the page side)
gem "vite_rails", "~> 3.0"
gem "inertia_rails", "~> 3.7"

# Background work
gem "sidekiq", "~> 7.3"
gem "sidekiq-cron", "~> 2.0"
gem "connection_pool", "~> 2.5"  # sidekiq 7.3 is incompatible with connection_pool 3.x

# Object storage (Active Storage → MinIO over the S3 API)
gem "aws-sdk-s3", "~> 1.180", require: false
gem "image_processing", "~> 1.13"

# Authorization
gem "cancancan", "~> 3.6"

# Auth (placeholder model with has_secure_password)
gem "bcrypt", "~> 3.1"

# Reads .env in development; production should set real env vars
gem "dotenv-rails", "~> 3.1", groups: [:development, :test]

gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails", "~> 6.5"
  gem "faker", "~> 3.5"
  gem "shoulda-matchers", "~> 8.0"
end

group :development do
  gem "web-console"
end
