# == Schema Information
# Schema version: 20110529105026
#
# Table name: users_roles
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  role_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class UsersRoles < ActiveRecord::Base
end
