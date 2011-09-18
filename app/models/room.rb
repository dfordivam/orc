class Room < ActiveRecord::Base
  belongs_to :building
 
  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
    self.is_ac = 0
    self.is_extensible = 0
    self.beds_extensible = 0
    self.empty_beds = 0
    self.occupied_beds = 0
  end
  validates :building_id, :presence => true
  validates :room_no, :presence => true
  validates :floor, :presence => true
  validates :total_beds, :presence => true
end
