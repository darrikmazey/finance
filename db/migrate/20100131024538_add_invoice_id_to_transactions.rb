class AddInvoiceIdToTransactions < ActiveRecord::Migration
  def self.up
		add_column :transactions, :invoice_id, :integer
  end

  def self.down
		remove_column :transactions, :invoice_id
  end
end
