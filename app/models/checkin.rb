# == Schema Information
# Schema version: 20110529105026
#
# Table name: checkins
#
#  id           :integer(4)      not null, primary key
#  checkin_date :date
#  checkin_time :time
#  no_of_days   :integer(4)
#  visitor_id   :integer(4)
#  event_id     :integer(4)
#  room_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Checkin < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :event
  belongs_to :room
end
