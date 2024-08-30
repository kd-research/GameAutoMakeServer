class AddRolesToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :roles, :string, default: 'user'
  end
end
