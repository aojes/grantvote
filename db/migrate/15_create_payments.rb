class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id
      t.integer :group_id
      t.decimal :amount, :precision => 9, :scale => 2
      t.string :express_token
      t.string :express_payer_id
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
