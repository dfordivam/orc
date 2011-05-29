class RenameRoomsToNoOfRoomsInBuilding < ActiveRecord::Migration
  def self.up
    rename_column :buildings, :rooms, :no_of_rooms
  end

  def self.down
    rename_column :buildings, :no_of_rooms, :rooms
  end
end
