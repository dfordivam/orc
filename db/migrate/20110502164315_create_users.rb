class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :role_id
      t.integer :roles_mask
      t.string :role
      t.string :username
      t.string :crypted_password 
      t.string :password_salt
      t.string :email
      t.string :persistence_token
      t.boolean :is_delete, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
