class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :rolename
      t.integer :is_delete

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
