class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :recipient_id
      t.integer :friend_id
      t.integer :parent_id
      t.string :type
      t.string :subject
      t.text :content
      t.datetime :emailed_at
      t.timestamps
    end
    add_index :notifications, :recipient_id
    add_index :notifications, :friend_id
    add_index :notifications, :type
  end

  def self.down
    drop_table :notifications
  end
end

