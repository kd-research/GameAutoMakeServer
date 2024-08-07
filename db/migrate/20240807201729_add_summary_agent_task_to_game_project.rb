class AddSummaryAgentTaskToGameProject < ActiveRecord::Migration[7.1]
  def change
    add_column :game_projects, :summary_agent_task, :text
  end
end
