class Building < ActiveRecord::Base
  has_many :rooms
 
  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
  end

 validates :name, :presence => true
 validates :floors, :presence => true, :inclusion => (1..30), :numericality => true

 # Wont show No. of Rooms in new add building page....
 # validates :no_of_rooms, :presence => true
end
