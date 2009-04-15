class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :interest
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :group_id
    add_index :memberships, :interest
  end

  def self.down
    remove_index :memberships, :user_id
    remove_index :memberships, :group_id
    remove_index :memberships, :interest
    drop_table :memberships
  end
end
