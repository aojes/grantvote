class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :administrative
      t.decimal :authority, :precision => 4, :scale => 3, :default => 0, :null => false
      t.decimal :specific_authority, 
                            :precision => 4, :scale => 3, :default => 0, :null => false
      t.decimal :statistic, :precision => 4, :scale => 3, :default => 0, :null => false
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
