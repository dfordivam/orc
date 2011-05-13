# == Schema Information
# Schema version: 20110513125313
#
# Table name: users
#
#  id               :integer         not null, primary key
#  username         :string(255)
#  crypted_password :string(255)
#  password_salt    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  role_id          :integer
#

class User < ActiveRecord::Base
  belongs_to :role

  validates :username , :presence => true, :length => { :minimum => 5} , :uniqueness => true
  validates :crypted_password, :presence => true
  validates :password_salt, :presence => true
  validates :role_id, :presence => true
end
