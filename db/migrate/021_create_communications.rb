class CreateCommunications < ActiveRecord::Migration
  def self.up
    create_table :communications do |t|
      t.string   :subject
      t.text     :content
      t.string   :type
      t.integer  :parent_id
      t.integer  :sender_id
      t.integer  :recipient_id
      t.datetime :sender_deleted_at
      t.datetime :sender_read_at
      t.datetime :recipient_deleted_at
      t.datetime :recipient_read_at
      t.datetime :replied_at
      t.integer  :conversation_id
      t.timestamps
    end

    add_index :communications, :conversation_id
    add_index :communications, :recipient_id
    add_index :communications, :sender_id
    add_index :communications, :type

  end

  def self.down
    drop_table :communications
  end
end
