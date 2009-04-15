class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name     
      t.string :purpose
      t.integer :members
      t.integer :dues, :default => 2, :null => false
      t.decimal :funds, :precision => 9, :scale => 2, :default => 0, :null => false
      t.integer :wait, :default => 7, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
