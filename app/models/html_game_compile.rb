class HtmlGameCompile < ApplicationRecord
  before_validation :build_game_compile, on: :create
  before_validation :set_model_type, on: :create
  validates :game_compile, presence: true

  has_one :game_compile, as: :gameable, dependent: :destroy
  has_one_attached :html_file

  def self.build(name:, description:)
    begin
      response = compile_by_llm(name, description)
    rescue GRPC::Unavailable, GRPC::Cancelled => e
      throw :build_abort, "Oops.. Game generator is down. Please come back later.\nDetails: #{e}"
    rescue GRPC::Unknown => e
      throw :build_abort, "Oops.. Generated game is not playable. Please try it again.\nDetails: #{e}"
    end

    sample = new_from_bytes(response.html.data)
    sample.save and return [sample, "Log not available."]

    throw :build_abort, "HTML build was not created."
  end

  def model
    model_type.constantize.find(id)
  end

  def html_bytes
    html_file.download
  end

  def game_project
    game_compile.game_project
  end

  private

  def self.new_from_bytes(html_bytes)
    html_file = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(html_bytes),
      filename: "index.html",
      content_type: "text/html"
    )
    self.new(html_file:)
  end

  def self.compile_by_llm(name, description)
    GameGenerator::CrewClient.new.generate_html_game(name:, description:)
  end

  def set_model_type
    self.model_type = self.class.name
  end
end
