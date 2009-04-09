class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :grant_id
      t.boolean :cast, :default => false, :null => false
      t.decimal :authority, :precision => 4, :scale => 3, :default => 0, :null => false
      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :group_id
    add_index :votes, :grant_id
  end

  def self.down
    remove_index :votes, :user_id
    remove_index :votes, :group_id
    remove_index :votes, :grant_id
    drop_table :votes
  end
end
