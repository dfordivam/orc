class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.string :name
      t.integer :no_of_rooms
      t.integer :floors
      t.boolean :is_delete, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :buildings
  end
end
