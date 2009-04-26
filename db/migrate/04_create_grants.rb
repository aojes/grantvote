class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :name
      t.text :proposal
      t.boolean :final, :default => false, :null => false
      t.boolean :awarded, :default => false, :null => false
      t.integer :amount, :default => 10, :null => false
      t.string :permalink
      t.timestamps
    end
    add_index :grants, :user_id
    add_index :grants, [:group_id, :final, :awarded], :unique => true
  end

  def self.down
    remove_index :grants, :user_id
    remove_index :grants, [:group_id, :final, :awarded]
    drop_table :grants
  end
end
