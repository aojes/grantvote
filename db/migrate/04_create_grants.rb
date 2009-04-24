class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :name
      t.text :proposal
      t.boolean :final, :default => false, :null => false
      t.boolean :awarded, :default => false, :null => false
      t.decimal :amount, :precision => 9, :scale => 2, :default => 0, :null => false
      t.string :permalink
      t.timestamps
    end
    add_index :grants, :user_id
    add_index :grants, :group_id
    add_index :grants, :final
    add_index :grants, :awarded
  end

  def self.down
    remove_index :grants, :user_id
    remove_index :grants, :group_id
    remove_index :grants, :final
    remove_index :grants, :awarded
    drop_table :grants
  end
end
