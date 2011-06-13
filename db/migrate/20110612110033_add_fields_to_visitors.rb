class AddFieldsToVisitors < ActiveRecord::Migration
  def self.up
    add_column :visitors, :dob, :date
    add_column :visitors, :in_gyan_years, :integer
    add_column :visitors, :centre_addr, :string
    add_column :visitors, :is_guide, :boolean
    add_column :visitors, :email, :string
    add_column :visitors, :qualification, :string
#    add_column :visitors, :no_of_children, :integer
#    add_column :visitors, :need_pickup, :boolean
#    add_column :visitors, :need_drop, :boolean
#    add_column :visitors, :pickup_time, :datetime
#    add_column :visitors, :pickup_place, :string
#    add_column :visitors, :drop_time, :datetime
#    add_column :visitors, :drop_place, :string
    add_column :visitors, :vehicle_no, :string
    add_column :visitors, :is_driver_along, :boolean
    add_column :visitors, :driver_name, :string
    add_column :visitors, :driver_contact_no, :integer
    add_column :visitors, :is_driver_accom_req, :boolean
    add_column :visitors, :is_driver_in_gyan, :boolean
    add_column :visitors, :type_of_food, :string
    add_column :visitors, :medicine_requirement, :string
    add_column :visitors, :remarks, :string
    add_column :visitors, :is_special_care_req, :boolean
    add_column :visitors, :is_physically_challenged, :boolean
    add_column :visitors, :create_by, :string
    add_column :visitors, :updated_by, :string
  end

  def self.down
    remove_column :visitors, :dob
    remove_column :visitors, :in_gyan_years
    remove_column :visitors, :centre_addr
    remove_column :visitors, :is_guide
    remove_column :visitors, :email
    remove_column :visitors, :qualification
#    remove_column :visitors, :no_of_children
#    remove_column :visitors, :need_pickup
#    remove_column :visitors, :need_drop
#    remove_column :visitors, :pickup_time
#    remove_column :visitors, :pickup_place
#    remove_column :visitors, :drop_time
#    remove_column :visitors, :drop_place
    remove_column :visitors, :vehicle_no
    remove_column :visitors, :is_driver_along
    remove_column :visitors, :driver_name
    remove_column :visitors, :driver_contact_no
    remove_column :visitors, :is_driver_accom_req
    remove_column :visitors, :is_driver_in_gyan
    remove_column :visitors, :type_of_food
    remove_column :visitors, :medicine_requirement
    remove_column :visitors, :remarks
    remove_column :visitors, :is_special_care_req
    remove_column :visitors, :is_physically_challenged
    remove_column :visitors, :create_by
    remove_column :visitors, :updated_by
  end
end
