# == Schema Information
# Schema version: 20110614113903
#
# Table name: rooms
#
#  id              :integer         not null, primary key
#  is_ac           :boolean
#  is_extensible   :boolean
#  beds_extensible :integer
#  floor           :integer
#  empty_beds      :integer
#  occupied_beds   :integer
#  category        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  building_id     :integer
#  room_no         :integer
#  total_beds      :integer
#

class Room < ActiveRecord::Base
  belongs_to :building
end
