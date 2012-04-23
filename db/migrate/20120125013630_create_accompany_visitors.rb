class CreateAccompanyVisitors < ActiveRecord::Migration
  def self.up
    create_table :accompany_visitors do |t|
      t.integer :registration_id
      t.integer :event_id
      t.string  :name
      t.string  :gender
      t.string  :visitor_type
      t.boolean :is_delete, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :accompany_visitors
  end
end
