# == Schema Information
# Schema version: 20110613040550
#
# Table name: visitors
#
#  id                       :integer(4)      not null, primary key
#  name                     :string(255)
#  age                      :integer(4)
#  address                  :string(255)
#  gender                   :boolean(1)
#  mobile_no                :integer(4)
#  visitor_type             :string(255)
#  designation              :string(255)
#  organisation             :string(255)
#  transport_mode           :string(255)
#  checkin_time             :time
#  checkin_date             :date
#  created_at               :datetime
#  updated_at               :datetime
#  dob                      :date
#  in_gyan_years            :integer(4)
#  centre_addr              :string(255)
#  is_guide                 :boolean(1)
#  email                    :string(255)
#  qualification            :string(255)
#  vehicle_no               :string(255)
#  is_driver_along          :boolean(1)
#  driver_name              :string(255)
#  driver_contact_no        :integer(4)
#  is_driver_accom_req      :boolean(1)
#  is_driver_in_gyan        :boolean(1)
#  type_of_food             :string(255)
#  medicine_requirement     :string(255)
#  remarks                  :string(255)
#  is_special_care_req      :boolean(1)
#  is_physically_challenged :boolean(1)
#  create_by                :string(255)
#  updated_by               :string(255)
#

class Visitor < ActiveRecord::Base
  has_many :checkins
#  attr_accessible :name, :age

  validates :name, :presence => true
end
