class Role < ActiveRecord::Base
  has_many :users #, :through => :users_roles
end