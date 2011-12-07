class ModifyRoomsAfterAddingRegistrations < ActiveRecord::Migration
  def self.up
    change_table :rooms do |t|
      t.integer :checkin_id
    end
  end

  def self.down
    change_table :rooms do |t|
      t.remove :checkin_id
    end
 end
end
