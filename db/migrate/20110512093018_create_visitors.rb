class CreateVisitors < ActiveRecord::Migration
  def self.up
    create_table :visitors do |t|
      t.string :name
      t.integer :age
      t.string :address
      t.boolean :gender
      t.integer :mobile_no
      t.string :visitor_type
      t.string :designation
      t.string :organisation
      t.string :transport_mode
      t.time :checkin_time
      t.date :checkin_date

      t.timestamps
    end
  end

  def self.down
    drop_table :visitors
  end
end
