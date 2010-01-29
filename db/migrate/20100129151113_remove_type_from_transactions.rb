class RemoveTypeFromTransactions < ActiveRecord::Migration
  def self.up
		remove_column :transactions, :type
  end

  def self.down
		add_column :transactions, :type, :string
  end
end
