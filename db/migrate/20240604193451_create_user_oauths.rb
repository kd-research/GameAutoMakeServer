class CreateUserOauths < ActiveRecord::Migration[7.1]
  def change
    create_table :user_oauths do |t|
      t.string :provider
      t.string :uid
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
