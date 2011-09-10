class Room < ActiveRecord::Base
  belongs_to :building
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end
  validates :building_id, :presence => true
  validates :room_no, :presence => true
end
