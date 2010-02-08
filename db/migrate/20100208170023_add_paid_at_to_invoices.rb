class AddPaidAtToInvoices < ActiveRecord::Migration
  def self.up
		add_column :invoices, :paid_at, :datetime
  end

  def self.down
		remove_column :invoices, :paid_at
  end
end
