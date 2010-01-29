class AddAmountToAccounts < ActiveRecord::Migration
  def self.up
		add_column :accounts, :amount, :float, :default => 0
  end

  def self.down
		remove_column :accounts, :amount
  end
end
