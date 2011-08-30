class Role < ActiveRecord::Base
  has_many :users_roles
  has_many :users, :through => :users_roles
end

# == Schema Information
# Schema version: 20110611144930
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  rolename   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

