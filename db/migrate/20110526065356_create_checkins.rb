class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.date    :checkin_date
      t.time    :checkin_time
      t.integer :no_of_days
      t.integer :visitor_id
      t.integer :event_id
      t.integer :room_id
      t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
