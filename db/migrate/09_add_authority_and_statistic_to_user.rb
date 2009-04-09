class AddAuthorityAndStatisticToUser < ActiveRecord::Migration
  def self.up
   # based on dues paid minus dues withdrawn
   add_column :users,  :authority, :decimal, :precision => 4, :scale => 3, :default => 0, :null => false

   # based on grants awarded
   add_column :users,  :statistic, :decimal, :precision => 4, :scale => 3, :default => 0, :null => false
  end

  def self.down
    remove_column :users,  :authority
    remove_column :users,  :statistic
  end
end
