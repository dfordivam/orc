class AddFieldToCheckins < ActiveRecord::Migration
  def self.up
    add_column :checkins, :is_accom_req, :boolean
    add_column :checkins, :meals_req, :integer
    add_column :checkins, :is_sight_seeing_req, :boolean
    add_column :checkins, :remarks, :string

#    add_column :checkins, :no_of_children, :integer
#    add_column :checkins, :need_pickup, :boolean
#    add_column :checkins, :need_drop, :boolean
#    add_column :checkins, :pickup_time, :datetime
#    add_column :checkins, :pickup_place, :string
#    add_column :checkins, :drop_time, :datetime
#    add_column :checkins, :drop_place, :string
  end

  def self.down
    remove_column :checkins, :is_accom_req
    remove_column :checkins, :meals_req
    remove_column :checkins, :is_sight_seeing_req
    remove_column :checkins, :remarks
#    remove_column :checkins, :no_of_children
#    remove_column :checkins, :need_pickup
#    remove_column :checkins, :need_drop
#    remove_column :checkins, :pickup_time
#    remove_column :checkins, :pickup_place
#    remove_column :checkins, :drop_time
#    remove_column :checkins, :drop_place
  end
end
