class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :group_id, :default => 0, :null => false
      t.string :name
      t.text :proposal, :limit => 15000
      t.text :media
      t.boolean :session, :default => false, :null => false
      t.boolean :final, :default => false, :null => false
      t.boolean :awarded, :default => false, :null => false
      t.integer :amount, :default => 10, :null => false
      t.string :permalink
      t.timestamps
    end
    add_index :grants, :user_id
    add_index :grants, :group_id
    add_index :grants, :session
    add_index :grants, :permalink
    add_index :grants, :name
    #add_index :grants, :proposal
  end

  def self.down

    drop_table :grants
  end
end

