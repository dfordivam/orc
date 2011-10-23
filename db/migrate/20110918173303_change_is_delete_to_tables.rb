class ChangeIsDeleteToTables < ActiveRecord::Migration
  def self.up
    add_column :buildings, :is_delete, :integer, :null => true
    add_column :checkins, :is_delete, :integer, :null => true
    add_column :events, :is_delete, :integer, :null => true
#    add_column :roles , :is_delete, :integer, :null => true
    add_column :rooms, :is_delete, :integer, :null => true
    add_column :users, :is_delete, :integer, :null => true
    add_column :users_roles, :is_delete, :integer, :null => true
  end

  def self.down
    remove_column :buildings, :is_delete, :integer
    remove_column :checkins, :is_delete, :integer
    remove_column :events, :is_delete, :integer
#    remove_column :roles , :is_delete, :integer
    remove_column :rooms, :is_delete, :integer
    remove_column :users, :is_delete, :integer
    remove_column :users_roles, :is_delete, :integer
  end
end
