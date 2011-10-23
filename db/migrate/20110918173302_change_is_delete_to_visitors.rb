class ChangeIsDeleteToVisitors < ActiveRecord::Migration
  def self.up
    add_column :visitors, :is_delete, :integer
  end

  def self.down
    remove_column :visitors, :is_delete
  end
end
