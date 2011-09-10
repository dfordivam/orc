class AddIsDeleteToBuildings < ActiveRecord::Migration
  def self.up
    add_column :buildings, :is_delete, :boolean
  end

  def self.down
    remove_column :buildings, :is_delete
  end
end
