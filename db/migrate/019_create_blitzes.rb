class CreateBlitzes< ActiveRecord::Migration
  def self.up
    create_table :blitzes do |t|
      t.integer :user_id
      t.integer :blitz_fund_id
      t.integer :votes_win
      t.string :name
      t.text :proposal
      t.text :media
      t.boolean :session, :default => false, :null => false
      t.boolean :final, :default => false, :null => false
      t.boolean :awarded, :default => false, :null => false
      t.integer :amount, :default => 20, :null => false
      t.string :permalink
      t.timestamps
    end

    add_index :blitzes, :user_id
    add_index :blitzes, :session
    add_index :blitzes, :permalink
  end

  def self.down

    drop_table :blitzes
  end
end

