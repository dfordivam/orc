# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110902131358) do

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.integer  "no_of_rooms"
    t.integer  "floors"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkins", :force => true do |t|
    t.date     "checkin_date"
    t.time     "checkin_time"
    t.integer  "no_of_days"
    t.integer  "visitor_id"
    t.integer  "event_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active"
    t.boolean  "is_accom_req"
    t.integer  "meals_req"
    t.boolean  "is_sight_seeing_req"
    t.string   "remarks"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.integer  "capacity"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.boolean  "is_ac"
    t.boolean  "is_extensible"
    t.integer  "beds_extensible"
    t.integer  "floor"
    t.integer  "empty_beds"
    t.integer  "occupied_beds"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "building_id"
    t.integer  "room_no"
    t.integer  "total_beds"
  end

  create_table "test", :id => false, :force => true do |t|
    t.string "Name", :limit => 20, :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  create_table "users_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["role_id"], :name => "index_users_roles_on_role_id"
  add_index "users_roles", ["user_id"], :name => "index_users_roles_on_user_id"

  create_table "visitors", :force => true do |t|
    t.string   "name"
    t.integer  "age"
    t.text     "address"
    t.string   "gender"
    t.string   "mobile_no"
    t.string   "visitor_type"
    t.string   "designation"
    t.string   "organisation"
    t.string   "transport_mode"
    t.time     "checkin_time"
    t.date     "checkin_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "dob"
    t.integer  "in_gyan_years"
    t.text     "centre_addr"
    t.string   "is_guide"
    t.string   "email"
    t.string   "qualification"
    t.string   "vehicle_no"
    t.string   "is_driver_along"
    t.string   "driver_name"
    t.string   "driver_contact_no"
    t.string   "is_driver_accom_req"
    t.string   "is_driver_in_gyan"
    t.string   "type_of_food"
    t.string   "medicine_requirement"
    t.string   "remarks"
    t.boolean  "is_special_care_req"
    t.string   "is_physically_challenged"
    t.string   "create_by"
    t.string   "updated_by"
    t.integer  "event_id"
  end

end
