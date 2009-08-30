class CreatePaymentTransactions < ActiveRecord::Migration
  def self.up
    create_table :payment_transactions do |t|
      t.integer :payment_id
      t.boolean :success
#      t.string :action
#      t.integer :amount
#      t.boolean :success
#      t.string :authorization
#      t.string :message
#      t.text :params

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_transactions
  end
end

