class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :ref
      t.string :description
      t.float :credit_amount
      t.float :debit_amount
      t.datetime :trans_date
      t.references :account

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
