class CreateBlitzFunds < ActiveRecord::Migration
  def self.up
    create_table :blitz_funds do |t|
      t.integer :dues
      t.integer :general_pool
      t.timestamps
    end
  end
  
  def self.down
    drop_table :blitz_funds
  end
end
