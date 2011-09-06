class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :role

  validates :username , :presence => true, :length => { :minimum => 5} , :uniqueness => true
  validates :crypted_password, :presence => true
  validates :password_salt, :presence => true
#  validates :role_id, :presence => true

  named_scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  ROLES = %w[admin moderator user]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

end

# == Schema Information
# Schema version: 20110611144930
#
# Table name: users
#
#  id               :integer(4)      not null, primary key
#  username         :string(255)
#  crypted_password :string(255)
#  password_salt    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  role_id          :integer(4)
#

