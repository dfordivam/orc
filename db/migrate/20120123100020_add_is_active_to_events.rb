class AddIsActiveToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :is_active, :boolean
    change_column :events, :is_delete, :boolean
  end

  def self.down
    remove_column :events, :is_active
    change_column :events, :is_delete, :integer
  end
end
