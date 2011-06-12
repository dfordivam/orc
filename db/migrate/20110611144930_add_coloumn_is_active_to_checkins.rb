class AddColoumnIsActiveToCheckins < ActiveRecord::Migration
  def self.up
    add_column :checkins, :is_active, :boolean
  end

  def self.down
    remove_column :checkins, :is_active
  end
end
