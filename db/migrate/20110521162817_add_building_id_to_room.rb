class AddBuildingIdToRoom < ActiveRecord::Migration
  def self.up
    add_column :rooms, :building_id, :integer
  end

  def self.down
    remove_column :rooms, :building_id
  end
end
