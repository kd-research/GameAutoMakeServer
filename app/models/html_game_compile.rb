class HtmlGameCompile < ApplicationRecord
  before_validation :build_game_compile, on: :create
  before_validation :set_model_type, on: :create

  def self.build(game_project)
    throw :build_abort, "'Conclude Chat' is required to build the game." unless game_project.game_generate_conversation.present?
    begin
      generated_description = game_project.game_generate_conversation.dialog.response_message
      response = compile_by_llm(game_project.name, generated_description)
    rescue GRPC::Unavailable
      throw :build_abort, "Oops.. Game generator is down. Please come back later."
    rescue GRPC::Unknown => e
      throw :build_abort, "Oops.. Generated game is not playable. Please try it again.\nDetails: #{e}"
    end

    sample = new_from_bytes(response.html.data)
    sample.save!

    throw :build_abort, "HTML build was not created." unless sample.save
    puts "project #{game_project.id} compile #{sample.game_compile.id} sample #{sample.id}"

    game_project.update!(game_compile: sample.game_compile)
    nil
  end

  def self.new_from_bytes(html_bytes)
    html_file = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(html_bytes),
      filename: "index.html",
      content_type: "text/html"
    )
    self.new(html_file:)
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

  has_one :game_compile, as: :gameable, dependent: :destroy
  has_one_attached :html_file

  private

  def self.compile_by_llm(name, description)
    GameGenerator::CrewClient.new.generate_html_game(name:, description:)
  end

  def set_model_type
    self.model_type = self.class.name
  end
end
