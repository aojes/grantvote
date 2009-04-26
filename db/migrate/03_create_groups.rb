class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name     
      t.string :purpose
      t.integer :dues, :default => 2, :null => false
      t.decimal :funds, :precision => 9, :scale => 2, :default => 0, :null => false
      t.string :permalink
      t.timestamps
    end
    add_index :groups, :name
  end

  def self.down
    remove_index :groups, :name
    drop_table :groups
  end
end
