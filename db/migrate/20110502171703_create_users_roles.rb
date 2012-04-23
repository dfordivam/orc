class CreateUsersRoles < ActiveRecord::Migration
  def self.up
    create_table :users_roles do |t|
      t.integer :user_id
      t.integer :role_id
      t.boolean :is_delete, :default => false
      t.timestamps
    end
    add_index :users_roles, :user_id
    add_index :users_roles, :role_id
  end

  def self.down
    drop_table :users_roles
  end
end
