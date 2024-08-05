class AddAgentInstructionsToGameProject < ActiveRecord::Migration[7.1]
  def change
    add_column :game_projects, :chat_agent_instruction, :text
    add_column :game_projects, :summary_agent_instruction, :text
  end
end
