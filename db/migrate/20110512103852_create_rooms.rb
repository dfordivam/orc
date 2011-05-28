class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.boolean :is_ac
      t.boolean :is_extensible
      t.integer :beds_extensible
      t.integer :floor
      t.integer :empty_beds
      t.integer :occupied_beds
      t.integer :category

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
