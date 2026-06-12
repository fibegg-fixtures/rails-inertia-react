require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  # /up returns 200 if the app boots; used by docker healthcheck and load balancers.
  get "up" => "rails/health#show", as: :rails_health_check

  # Sidekiq Web UI, gated by HTTP basic auth using SIDEKIQ_USER/SIDEKIQ_PASSWORD.
  if ENV["SIDEKIQ_USER"].present? && ENV["SIDEKIQ_PASSWORD"].present?
    Sidekiq::Web.use(Rack::Auth::Basic) do |user, pass|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(user),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USER"]),
      ) & ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(pass),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]),
      )
    end
  end
  mount Sidekiq::Web => "/sidekiq"

  resources :uploads, only: [:create]

  root "home#index"
end
