# == Schema Information
# Schema version: 20110614113903
#
# Table name: checkins
#
#  id                  :integer         not null, primary key
#  checkin_date        :date
#  checkin_time        :time
#  no_of_days          :integer
#  visitor_id          :integer
#  event_id            :integer
#  room_id             :integer
#  created_at          :datetime
#  updated_at          :datetime
#  is_active           :boolean
#  is_accom_req        :boolean
#  meals_req           :integer
#  is_sight_seeing_req :boolean
#  remarks             :string(255)
#

class Checkin < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :event
  belongs_to :room
end
