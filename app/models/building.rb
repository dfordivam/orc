class Building < ActiveRecord::Base
  has_many :rooms
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end

 validates :name, :presence => true
  validates :no_of_rooms, :presence => true
end
