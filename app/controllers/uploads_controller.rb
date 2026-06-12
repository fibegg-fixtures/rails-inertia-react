class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create] # Inertia handles CSRF on its own

  def create
    file = params[:file]
    if file.blank?
      redirect_to root_path, alert: "No file provided" and return
    end

    blob = ActiveStorage::Blob.create_and_upload!(io: file.tempfile, filename: file.original_filename, content_type: file.content_type)
    redirect_to root_path, notice: "Uploaded #{blob.filename}"
  end
end
