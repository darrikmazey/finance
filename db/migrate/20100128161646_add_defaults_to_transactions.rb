class AddDefaultsToTransactions < ActiveRecord::Migration
  def self.up
		change_column :transactions, :credit_amount, :float, :default => 0
		change_column :transactions, :debit_amount, :float, :default => 0
  end

  def self.down
		change_column :transactions, :debit_amount, :float
		change_column :transactions, :credit_amount, :float
  end
end
