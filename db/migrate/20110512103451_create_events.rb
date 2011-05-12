class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.integer :capacity
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
