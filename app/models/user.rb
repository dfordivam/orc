# == Schema Information
# Schema version: 20110512103852
#
# Table name: users
#
#  id               :integer         not null, primary key
#  username         :string(255)
#  crypted_password :string(255)
#  password_salt    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class User < ActiveRecord::Base
  belongs_to :role
end
