class AssignDefaultInstructionsToGameProject < ActiveRecord::Migration[7.1]
  include CrewFlavored
  def up
    GameProject.all.each do |project|
      project.update!(
        chat_agent_instruction: game_consultant_flavored,
        summary_agent_instruction: game_developer_flavored
      )
    end
  end

  def down
    GameProject.all.each do |project|
      project.update!(
        chat_agent_instruction: nil,
        summary_agent_instruction: nil
      )
    end
  end
end
