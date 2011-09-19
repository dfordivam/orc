class ChangeRoomNoDataTypeToString < ActiveRecord::Migration
  def self.up
    change_column :rooms, :room_no, :string, :null => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
