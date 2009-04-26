class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :login
      t.string :name
      t.text :detail
      t.string :link
      t.string :location
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
