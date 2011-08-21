class ChangeVisitorsSomeColumntype < ActiveRecord::Migration
  def self.up
    change_column :visitors, :is_physically_challenged, :string
    change_column :visitors, :is_guide, :string
    change_column :visitors, :is_driver_along, :string
    change_column :visitors, :is_driver_accom_req, :string
    change_column :visitors, :is_driver_in_gyan, :string
  end

  def self.down
    change_column :visitors, :is_physically_challenged, :boolean
    change_column :visitors, :is_guide, :boolean
    change_column :visitors, :is_driver_along, :boolean
    change_column :visitors, :is_driver_accom_req, :boolean
    change_column :visitors, :is_driver_in_gyan, :boolean
  end
end
