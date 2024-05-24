class UnityStorageDiskController < ActiveStorage::DiskController
  def show
    if key = decode_verified_key
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
end
