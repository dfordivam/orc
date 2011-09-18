class Checkin < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :event
  belongs_to :room
 
  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
    self.is_active = 1
    self.is_accom_req = 1
    self.is_sight_seeing_req = 0
  end

  validates :visitor_id, :presence => true
  validates :event_id, :presence => true
  validates :room_id, :presence => true
  validates :no_of_days, :presence => true
end
