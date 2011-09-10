class Checkin < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :event
  belongs_to :room
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end

end
