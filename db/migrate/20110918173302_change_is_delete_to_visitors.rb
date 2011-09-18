class ChangeIsDeleteToVisitors < ActiveRecord::Migration
  def self.up
    change_column :visitors, :is_delete, :integer, :null => true
  end

  def self.down
  end
end
