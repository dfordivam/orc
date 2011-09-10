class AddIsDeleteToTables < ActiveRecord::Migration
  def self.up
    add_column :checkins, :is_delete, :boolean
    add_column :events, :is_delete, :boolean
    add_column :roles , :is_delete, :boolean
    add_column :rooms, :is_delete, :boolean
    add_column :users, :is_delete, :boolean
    add_column :users_roles, :is_delete, :boolean
    add_column :visitors, :is_delete, :boolean
  end

  def self.down
    remove_column :checkins, :is_delete
    remove_column :events, :is_delete
    remove_column :roles , :is_delete
    remove_column :rooms, :is_delete
    remove_column :users, :is_delete
    remove_column :users_roles, :is_delete
    remove_column :visitors, :is_delete
  end
end
