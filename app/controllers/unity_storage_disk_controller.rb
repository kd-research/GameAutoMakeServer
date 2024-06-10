class UnityStorageDiskController < ActiveStorage::DiskController
  # @deprecated
  def show
    if (key = decode_verified_key)
      super
      if response_code == 200
        blob = ActiveStorage::Blob.where(key: key[:key]).first
        extra_headers = blob.custom_metadata
        response.headers["Content-Encoding"] = extra_headers["content_encoding"] if extra_headers["content_encoding"]
      end
    else
      head :not_found
    end
  end

  deprecate show: <<~MSG.squish, deprecator: Rails.application.deprecator
    Local file serving is deprecated. Please use a web server for this functionality, or use a service like S3 to store and serve files.
  MSG
end
