class ModifyCheckinsAfterAddingRegistrations < ActiveRecord::Migration
  def self.up
    change_table :checkins do |t|
      t.remove :room_id, :is_accom_req, :meals_req, :is_sight_seeing_req

      t.integer :registration_id
      t.date :checkout_date
      t.time :checkout_time

    end
  end

  def self.down
    change_table :checkins do |t|
      t.integer :room_id, :meals_req
      t.boolean :is_accom_req, :is_sight_seeing_req

      t.remove :registration_id, :checkout_date, :checkout_time

    end
  end
end
