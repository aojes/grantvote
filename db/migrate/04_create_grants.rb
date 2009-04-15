class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :group_id
      # Q. Would it work better to parameterize the grant name?
      #    so that if grant ID=20 & Group ID=1, first grant = /groups/1/grants/1
      # t.integer :group_index (?)
      t.string :name, :default => "", :null => false
      t.text :proposal, :default => "", :null => false
      t.datetime :expires, :null => true
      t.boolean :current, :default => true, :null => false
      t.boolean :awarded, :default => false, :null => false
      t.decimal :amount, :precision => 9, :scale => 2, :default => 0, :null => false
      t.timestamps
    end
    add_index :grants, :user_id
    add_index :grants, :group_id
    add_index :grants, :current
    add_index :grants, :awarded
  end

  def self.down
    remove_index :grants, :user_id
    remove_index :grants, :group_id
    remove_index :grants, :current
    remove_index :grants, :awarded
    drop_table :grants
  end
end
