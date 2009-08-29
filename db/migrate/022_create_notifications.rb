class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.string :event, :default => 'Payment', :null => false
      t.string :url
      t.timestamps
    end
    add_index :notifications, :user_id
  end

  def self.down
    drop_table :notifications
  end
end

