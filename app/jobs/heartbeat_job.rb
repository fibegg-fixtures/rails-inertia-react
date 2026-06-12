class HeartbeatJob < ApplicationJob
  queue_as :default

  COUNTER_KEY = "rails-inertia-react:heartbeats".freeze

  def perform
    n = Sidekiq.redis { |c| c.incr(COUNTER_KEY) }
    Rails.logger.info("[heartbeat] tick=#{n}")
    n
  end

  def self.fired_count
    Sidekiq.redis { |c| c.get(COUNTER_KEY).to_i }
  rescue StandardError
    0
  end
end
