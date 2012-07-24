class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :rolename
      t.boolean :is_delete, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
