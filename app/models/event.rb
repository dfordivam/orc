class Event < ActiveRecord::Base
 
  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
  end
  validates :name, :presence => true
  validates :start_date_time, :presence => true
  validates :end_date_time, :presence => true
  validates :location, :presence => true
end
