class ModifyUsersForAuthlogic < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string, :null => false, :default => 'default'
    add_column :users, :persistence_token, :string,  :null => false, :default => '0'
    add_column :users, :perishable_token, :string, :null => false, :default => '0'
    add_column :users, :login_count, :integer, :null => false, :default => 0
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
  end

  def self.down
    remove_column :users, :login
    remove_column :users, :persistence_token
    remove_column :users, :perishable_token
    remove_column :users, :login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
  end
end
