class HtmlGameCompile < ApplicationRecord
  def self.new_from_bytes(html_bytes)
    html_file = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(html_bytes),
      filename: "index.html",
      content_type: "text/html"
    )
    new(html_file:)
  end

  def html_bytes
    html_file.download
  end

  belongs_to :game_project
  has_one_attached :html_file
end
