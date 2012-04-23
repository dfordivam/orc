class Role < ActiveRecord::Base
  has_many :users #, :through => :users_roles
 
  before_create :set_default_values
  
  def set_default_values
    self.is_delete = 0
  end
  validates :rolename, :presence => true
end