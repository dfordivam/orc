class ChangeVisitorsMobileColumntype < ActiveRecord::Migration
  def self.up
    change_column :visitors, :mobile_no, :string
    change_column :visitors, :driver_contact_no, :string
  end

  def self.down
    change_column :visitors, :mobile_no, :integer
    change_column :visitors, :driver_contact_no, :integer
  end
end
