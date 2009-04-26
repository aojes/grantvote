class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :group_id, :null => false
      t.integer :grant_id, :null => false
      t.string :cast, :null => false
      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, [:group_id, :grant_id]
  end

  def self.down
    remove_index :votes, :user_id
    remove_index :votes, [:group_id, :grant_id]
    drop_table :votes
  end
end
