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

ActiveRecord::Schema.define(:version => 20110521152423) do

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.integer  "rooms"
    t.integer  "floors"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "address"
    t.boolean  "gender"
    t.integer  "mobile_no"
    t.string   "visitor_type"
    t.string   "designation"
    t.string   "organisation"
    t.string   "transport_mode"
    t.time     "checkin_time"
    t.date     "checkin_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
