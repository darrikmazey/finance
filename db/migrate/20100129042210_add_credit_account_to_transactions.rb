class AddCreditAccountToTransactions < ActiveRecord::Migration
  def self.up
		add_column :transactions, :credit_account_id, :integer
  end

  def self.down
		remove_column :transactions, :credit_account_id
  end
end
