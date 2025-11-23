# frozen_string_literal: true

# Only authenticated users can access active storage blobs
class SecureBlobsController < ActiveStorage::BaseController
  include ActiveStorage::SetBlob

  before_action :authenticate_user!

  def show
    expires_in ActiveStorage.service_urls_expire_in
    redirect_to @blob.url(disposition: params[:disposition]), allow_other_host: true
  end
end
