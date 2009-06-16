class CreateGrants < ActiveRecord::Migration
  def self.up
    create_table :grants do |t|
      t.integer :user_id
      t.integer :group_id, :default => 0, :null => false
      t.string :name
      t.text :proposal
      t.text :media
      t.boolean :final, :default => false, :null => false
      t.boolean :awarded, :default => false, :null => false
      t.integer :amount, :default => 5, :null => false
      t.string :permalink
      t.timestamps
    end
    add_index :grants, :user_id
    add_index :grants, :group_id
    add_index :grants, :permalink
  end

  def self.down

    drop_table :grants
  end
end
