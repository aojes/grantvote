class CreateBlitzFunds < ActiveRecord::Migration
  def self.up
    create_table :blitz_funds do |t|
      t.decimal :dues, :default => 4.85, :precision => 9, :scale => 2, :null => false
      t.integer :general_pool, :default => 0, :null => false
      t.integer :awards, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :blitz_funds
  end
end

