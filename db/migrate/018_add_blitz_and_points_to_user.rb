class AddBlitzAndPointsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :blitz_interest, :boolean, :default => false, :null => false
    add_column :users, :blitz_contributes, :decimal, :default => 0, :null => false, :precision => 9, :scale => 2
    add_column :users, :blitz_rewards, :integer, :default => 0, :null => false
    add_column :users, :points, :integer, :default => 1, :null => false
  end

  def self.down
    remove_column :users, :blitz_contributes
    remove_column :users, :blitz_rewards
    remove_column :users, :points
    remove_column :users, :blitz_interest
  end
end

