class AssignConversationsToGameProjects < ActiveRecord::Migration[7.1]
  def up
    GameProject.all.each do |game_project|
      game_project.chat_conversation = Conversation.create!
      game_project.save!
    end
  end

  def down
    GameProject.all.each do |game_project|
      game_project.chat_conversation.destroy!
    end
  end
end
