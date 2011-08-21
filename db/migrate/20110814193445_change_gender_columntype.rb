class ChangeGenderColumntype < ActiveRecord::Migration
  def self.up
    change_column :visitors, :gender, :string
  end

  def self.down
    change_column :visitors, :gender, :boolean
  end
end
