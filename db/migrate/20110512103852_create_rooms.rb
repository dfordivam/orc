class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.integer :building_id
      t.integer :floor
      t.string :room_no, :null => false
      t.integer :total_beds
      t.integer :empty_beds, :default => 0
      t.integer :occupied_beds, :default => 0
      t.integer :beds_extensible, :default => 0
      t.integer :category
      t.boolean :is_ac, :default => false
      t.boolean :is_extensible, :default => false
      t.boolean :is_delete, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
