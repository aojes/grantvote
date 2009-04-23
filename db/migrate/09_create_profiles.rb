class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :name
      t.text :bio
      t.string :link
      t.string :location

      t.timestamps
    end
    add_index :profiles, :user_id
  end

  def self.down
    remove_index :profiles, :user_id
    drop_table :profiles
  end
end
