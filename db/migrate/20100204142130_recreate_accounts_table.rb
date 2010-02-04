class RecreateAccountsTable < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :description
      t.float :initial_balance, :default => 0
      t.string :type
      t.references :user
      t.datetime :due_date
      t.integer :period
			t.string :account_number
			t.float :amount, :default => 0
			t.parent :references

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
