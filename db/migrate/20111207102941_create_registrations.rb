class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.integer :visitor_id
      t.integer :event_id
      t.integer :accompanying_males
      t.integer :accompanying_females
      t.string :remarks
      t.boolean :is_accom_req
      t.boolean :is_delete, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
