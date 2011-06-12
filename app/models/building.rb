# == Schema Information
# Schema version: 20110611144930
#
# Table name: buildings
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  no_of_rooms :integer(4)
#  floors      :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Building < ActiveRecord::Base
  has_many :rooms
  validates :name, :presence => true
  validates :no_of_rooms, :presence => true
end
