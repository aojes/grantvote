class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :interest
      t.string  :role, :default => "basic", :null => false
      t.boolean :public, :default => true, :null => false
      t.decimal :contributes, :precision => 9, :scale => 2, :default => 0, :null => false
      t.decimal :rewards, :precision => 9, :scale => 3, :default => 0, :null => false
      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :group_id
  end

  def self.down

    drop_table :memberships
  end
end
