class GameProject < ApplicationRecord
  include CrewFlavored
  before_validation :build_chat_conversation, on: :create
  before_validation :fill_default_instructions, on: :create
  before_validation :alter_default_compile_type, on: :create
  before_save :reset_game_compile, if: :compile_type_changed?

  has_one :game_compile, dependent: :destroy
  def gameable = game_compile&.gameable

  belongs_to :user
  belongs_to :chat_conversation, class_name: "Conversation"
  belongs_to :game_generate_conversation, class_name: "Conversation", optional: true

  enum privacy: %w[public unlisted private].to_h { [_1, _1] }, _prefix: true
  enum compile_type: %w[html html_demo].to_h { [_1, _1] }, _prefix: true

  def gameklass
    case compile_type
    when "unity" then WebglGameCompile
    when "html" then HtmlGameCompile
    when "html_demo" then HtmlDemoGameCompile
    end
  end


  def build_game
    gameklass.build(self)
  end

  private

  def reset_game_compile
    game_compile&.destroy!
  end

  def fill_default_instructions
    self.chat_agent_instruction = game_consultant_flavored
    self.summary_agent_instruction = game_developer_flavored
    self.summary_agent_task = game_summary_start_note
  end

  def alter_default_compile_type
    self.compile_type = "html"
  end
end
