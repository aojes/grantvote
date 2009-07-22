class AddFieldsToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :sender_id, :string
    add_column :invitations, :token, :string
    add_column :invitations, :sent_at, :datetime

    add_index :invitations, :sender_id
    add_index :invitations, :token
    add_index :invitations, :sent_at
  end

  def self.down
    remove_column :invitations, :sender_id
    remove_column :invitations, :sent_at
  end
end
