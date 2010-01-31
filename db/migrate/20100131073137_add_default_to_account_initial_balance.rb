class AddDefaultToAccountInitialBalance < ActiveRecord::Migration
  def self.up
		change_column :accounts, :initial_balance, :float, :default => 0
  end

  def self.down
		change_column :accounts, :initial_balance, :float
  end
end
