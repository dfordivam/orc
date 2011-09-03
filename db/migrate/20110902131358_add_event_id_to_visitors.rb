class AddEventIdToVisitors < ActiveRecord::Migration
  def self.up
    add_column :visitors, :event_id, :integer
  end

  def self.down
    remove_column :visitors, :event_id
  end
end
