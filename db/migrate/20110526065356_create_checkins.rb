class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
       t.integer :source_id
       t.string  :source_type
       t.integer :building_id
       t.integer :floor_id
       t.integer :room_id
       t.boolean :is_active, :default => true
       t.boolean :is_delete, :default => false
       t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
