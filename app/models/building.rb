# == Schema Information
# Schema version: 20110614113903
#
# Table name: buildings
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  no_of_rooms :integer
#  floors      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Building < ActiveRecord::Base
  has_many :rooms
  validates :name, :presence => true
  validates :no_of_rooms, :presence => true
end
