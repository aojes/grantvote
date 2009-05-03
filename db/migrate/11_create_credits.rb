class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :credits do |t|
      t.integer :user_id
      t.integer :points, :default => 0, :null => false
      t.integer :laurels, :default => 0, :null => false
      t.integer :ribbons, :default => 0, :null => false
      t.integer :pearls, :default => 0, :null => false
      t.integer :shells, :default => 0, :null => false
      t.integer :pebbles, :default => 0, :null => false
      t.integer :beads, :default => 0, :null => false
      t.integer :buttons, :default => 0, :null => false
      t.integer :pens, :default => 0, :null => false

      t.timestamps
    end
    add_index :credits, :user_id
    add_index :credits, :points
  end

  def self.down
    remove_index :credits, :user_id
    remove_index :credits, :points
    drop_table :credits
  end
end
