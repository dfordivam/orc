class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :role
 
  before_create :set_is_delete_to_false
  
  def set_is_delete_to_false
    self.is_delete = 0
  end

  validates :username, :presence => true, :length => { :minimum => 5} , :uniqueness => true
  validates :email, :presence => true
  validates :crypted_password, :presence => true
  validates :password_salt, :presence => true
  validates :role_id, :presence => true

#  named_scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  ROLES = %w[admin moderator user]

  def role?(rolename)
#    ROLES.include? role.to_s
    role.rolename == rolename.to_s
  end

end
