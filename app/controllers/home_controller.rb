class HomeController < ApplicationController
  def index
    uploads = ActiveStorage::Blob.order(id: :desc).limit(10).map do |b|
      { id: b.id, filename: b.filename.to_s, url: Rails.application.routes.url_helpers.rails_blob_url(b, host: request.base_url) }
    end

    render inertia: "Home", props: {
      name: "World",
      heartbeats: HeartbeatJob.fired_count,
      uploads: uploads,
    }
  end
end
