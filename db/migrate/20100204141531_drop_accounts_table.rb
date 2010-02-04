class DropAccountsTable < ActiveRecord::Migration
  def self.up
		drop_table :accounts
  end

  def self.down
  end
end
