# == Schema Information
# Schema version: 20110614113903
#
# Table name: visitors
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  age                      :integer
#  address                  :string(255)
#  gender                   :boolean
#  mobile_no                :integer
#  visitor_type             :string(255)
#  designation              :string(255)
#  organisation             :string(255)
#  transport_mode           :string(255)
#  checkin_time             :time
#  checkin_date             :date
#  created_at               :datetime
#  updated_at               :datetime
#  dob                      :date
#  in_gyan_years            :integer
#  centre_addr              :string(255)
#  is_guide                 :boolean
#  email                    :string(255)
#  qualification            :string(255)
#  vehicle_no               :string(255)
#  is_driver_along          :boolean
#  driver_name              :string(255)
#  driver_contact_no        :integer
#  is_driver_accom_req      :boolean
#  is_driver_in_gyan        :boolean
#  type_of_food             :string(255)
#  medicine_requirement     :string(255)
#  remarks                  :string(255)
#  is_special_care_req      :boolean
#  is_physically_challenged :boolean
#  create_by                :string(255)
#  updated_by               :string(255)
#

class Visitor < ActiveRecord::Base
  has_many :checkins
#  attr_accessible :name, :age

  validates :name, :presence => true
end
