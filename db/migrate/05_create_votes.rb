class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :administrative
      t.decimal :authority, :precision => 10, :scale => 1, :default => 1, :null => false
      t.decimal :specific_authority, :precision => 10, :scale => 1, :default => 1, :null => false
      t.decimal :statistic, :precision => 5, :scale => 5
      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :group_id
  end

  def self.down
    remove_index :votes, :user_id
    remove_index :votes, :group_id
    drop_table :votes
  end
end
