class AddColumnTotalBedsToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :total_beds, :integer
  end

  def self.down
    remove_column :rooms, :total_beds
  end
end
