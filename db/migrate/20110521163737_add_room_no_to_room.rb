class AddRoomNoToRoom < ActiveRecord::Migration
  def self.up
    add_column :rooms, :room_no ,:integer
  end

  def self.down
    remove_column :rooms, :room_no
  end
end
