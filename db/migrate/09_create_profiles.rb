class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :login
      t.string :name, :null => false, :default => ""
      t.string :detail, :null => false, :default => ""
      t.string :link, :null => false, :default => "http://"
      t.string :location, :null => false, :default => ""
      t.string :permalink
      t.timestamps
    end
    add_index :profiles, :user_id
  end

  def self.down
    remove_index :profiles, :user_id
    drop_table :profiles
  end
end
