# == Schema Information
# Schema version: 20110512103852
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
#

class Room < ActiveRecord::Base
end
