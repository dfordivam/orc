class ChangeIsDeleteToTables < ActiveRecord::Migration
  def self.up
    change_column :buildings, :is_delete, :integer, :null => true
    change_column :checkins, :is_delete, :integer, :null => true
    change_column :events, :is_delete, :integer, :null => true
    change_column :roles , :is_delete, :integer, :null => true
    change_column :rooms, :is_delete, :integer, :null => true
    change_column :users, :is_delete, :integer, :null => true
    change_column :users_roles, :is_delete, :integer, :null => true
  end

  def self.down
  end
end
