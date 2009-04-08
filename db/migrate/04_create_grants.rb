class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :group_id
      t.text :proposal
      t.boolean :awarded, :default => false
      t.decimal :amount, :precision => 9, :scale => 2, :default => 0, :null => false
      t.timestamps
    end
    add_index :grants, :user_id
    add_index :grants, :group_id
  end

  def self.down
    remove_index :grants, :user_id
    remove_index :grants, :group_id
    drop_table :grants
  end
end
