class ChangeAccountToDebitAccountForTransactions < ActiveRecord::Migration
  def self.up
		rename_column :transactions, :account_id, :debit_account_id
  end

  def self.down
		rename_column :transactions, :debit_account_id, :account_id
  end
end
