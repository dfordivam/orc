class Building < ActiveRecord::Base
  has_many :rooms
  validates :name, :presence => true
  validates :no_of_rooms, :presence => true
end
