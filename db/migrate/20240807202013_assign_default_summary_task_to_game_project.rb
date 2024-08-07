class AssignDefaultSummaryTaskToGameProject < ActiveRecord::Migration[7.1]
  def up
    GameProject.all.each do |project|
      project.update!(
        summary_agent_task: "Write a summary of the game project."
      )
    end
  end

  def down
    # no-op
  end
end
