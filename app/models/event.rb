class Event < ActiveRecord::Base
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end

end
