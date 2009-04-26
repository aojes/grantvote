class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :interest
      t.string  :role, :default => "basic", :null => false
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :group_id
  end

  def self.down
    remove_index :memberships, :user_id
    remove_index :memberships, :group_id
    drop_table :memberships
  end
end
