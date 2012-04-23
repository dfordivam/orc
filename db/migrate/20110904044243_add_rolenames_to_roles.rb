class AddRolenamesToRoles < ActiveRecord::Migration
  def self.up
    Role.create(:rolename => 'admin')
    Role.create(:rolename => 'moderator')
    Role.create(:rolename => 'user')
  end

  def self.down
    Role.delete(:rolename => 'admin')
    Role.delete(:rolename => 'moderator')
    Role.delete(:rolename => 'user')
  end
end
