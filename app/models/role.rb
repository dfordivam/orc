class Role < ActiveRecord::Base
  has_many :users #, :through => :users_roles
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end
  validates :rolename, :presence => true
end