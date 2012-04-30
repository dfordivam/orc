class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.text :address
      t.text :centre_addr
      t.string :mobile_no
      t.string :visitor_type
      t.string :designation
      t.string :organisation
      t.string :transport_mode
      t.string :email
      t.string :qualification
      t.string :vehicle_no
      t.string :type_of_food
      t.string :medicine_requirement
      t.string :remarks
      t.date :dob
      t.integer :in_gyan_years
      t.boolean :is_guide
      t.boolean :is_driver_along
      t.string :driver_name
      t.string :driver_contact_no
      t.boolean :is_driver_accom_req
      t.boolean :is_driver_in_gyan
      t.boolean :is_special_care_req
      t.boolean :is_physically_challenged
      t.string :create_by
      t.string :updated_by
      t.boolean :is_delete, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :visitors
  end
end
