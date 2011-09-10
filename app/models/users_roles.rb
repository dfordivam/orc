class UsersRoles < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end

end

# == Schema Information
# Schema version: 20110611144930
#
# Table name: users_roles
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  role_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#
