# == Schema Information
# Schema version: 20110611144930
#
# Table name: rooms
#
#  id              :integer(4)      not null, primary key
#  is_ac           :boolean(1)
#  is_extensible   :boolean(1)
#  beds_extensible :integer(4)
#  floor           :integer(4)
#  empty_beds      :integer(4)
#  occupied_beds   :integer(4)
#  category        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  building_id     :integer(4)
#  room_no         :integer(4)
#  total_beds      :integer(4)
#

class Room < ActiveRecord::Base
  belongs_to :building
end
