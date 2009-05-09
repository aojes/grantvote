class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name     
      t.string :purpose
      t.integer :dues, :default => 5, :null => false
      t.decimal :funds, :precision => 9, :scale => 2, :default => 0, :null => false
      t.string :permalink
      t.timestamps
    end
    add_index :groups, :name
    add_index :groups, :purpose
  end

  def self.down
    remove_index :groups, :name
    remove_index :groups, :purpose
    drop_table :groups
  end
end
