# == Schema Information
# Schema version: 20110607115529
#
# Table name: checkins
#
#  id           :integer         not null, primary key
#  checkin_date :date
#  checkin_time :time
#  no_of_days   :integer
#  visitor_id   :integer
#  event_id     :integer
#  room_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Checkin < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :event
  belongs_to :room
end
