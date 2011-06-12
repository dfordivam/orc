class AddFieldsToVisitors < ActiveRecord::Migration
  def self.up
    add_column :visitors, :dob, :date
    add_column :visitors, , :string
    add_column :visitors, , :string
  end

  def self.down
  end
end
