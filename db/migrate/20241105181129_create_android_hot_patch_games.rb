class CreateAndroidHotPatchGames < ActiveRecord::Migration[7.2]
  def change
    create_table :android_hot_patch_games do |t|
      t.string :name

      t.timestamps
    end

    execute "ALTER SEQUENCE android_hot_patch_games_id_seq START WITH 100 RESTART;"
  end
end
