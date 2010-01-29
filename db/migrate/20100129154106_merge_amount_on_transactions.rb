class MergeAmountOnTransactions < ActiveRecord::Migration
  def self.up
		remove_column :transactions, :credit_amount
		rename_column :transactions, :debit_amount, :amount
  end

  def self.down
		rename_column :transactions, :amount, :debit_amount
		add_column :transactions, :credit_amount, :float, :default => 0
  end
end
