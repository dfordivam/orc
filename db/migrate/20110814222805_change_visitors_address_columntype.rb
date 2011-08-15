class ChangeVisitorsAddressColumntype < ActiveRecord::Migration
  def self.up
    change_column :visitors, :address, :text
    change_column :visitors, :centre_addr, :text
  end

  def self.down
    change_column :visitors, :address, :string
    change_column :visitors, :centre_addr, :string
  end
end
