class ModifyVisitorsAfterAddingRegistrations < ActiveRecord::Migration
  def self.up
    change_table :visitors do |t|
      t.remove :event_id, :checkin_time, :checkin_date
    end
  end

  def self.down
    change_table :visitors do |t|
      t.integer :event_id
      t.date :checkin_date
      t.time :checkin_time
    end
  end
end
