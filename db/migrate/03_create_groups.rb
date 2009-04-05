class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name            
      t.string :purpose
      t.integer :principals
      t.integer :members
      t.integer :dues,           :default => 1, :null => false
      t.decimal :dues_collected, :precision => 9, :scale => 2
      t.integer :grants_written
      t.integer :votes_held
      t.decimal :yield_average,  :precision => 9, :scale => 2
      t.integer :wait,           :default => 7
      t.decimal :withdrawals,    :precision => 9, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
