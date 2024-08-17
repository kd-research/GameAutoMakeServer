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

  GameCompileTypes = {
    html: HtmlGameCompile,
    html_stable: HtmlStableCompile,
    html_nightly: HtmlNightlyCompile,
    html_demo: HtmlDemoGameCompile
  }.stringify_keys.freeze


  def gameklass = GameCompileTypes[compile_type]

  enum privacy: %w[public unlisted private].to_h { [_1, _1] }, _prefix: true
  enum compile_type: GameCompileTypes.keys.to_h { [_1, _1] }, _prefix: true
  def visible_compile_types
    default_visible_types = %w[html_stable html_nightly].to_set
    default_visible_types << compile_type
    self.class.compile_types.slice(*default_visible_types)
  end

  def game_compile_data
    {
      name: name,
      description: game_generate_conversation.dialog.response_message
    }
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
