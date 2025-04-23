class AddGroupsToAndroidHotPatchGames < ActiveRecord::Migration[7.2]
  def change
    add_column :android_hot_patch_games, :groups, :string, default: "", null: false
  end
end
