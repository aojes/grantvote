class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name            
      t.string :purpose
      t.integer :principals
      t.integer :members
      t.integer :dues,           :default => 2, :null => false
      t.decimal :dues_collected, :precision => 9, :scale => 2, :default => 0, :null => false
      t.integer :grants_written, :default => 0, :null => false
      t.integer :votes_held, :default => 0, :null => false
      t.decimal :yield_average,  :precision => 9, :scale => 2, :default => 0, :null => false
      t.integer :wait,           :default => 7, :null => false
      t.decimal :withdrawals,    :precision => 9, :scale => 2, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
