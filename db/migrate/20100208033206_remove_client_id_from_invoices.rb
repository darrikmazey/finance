class RemoveClientIdFromInvoices < ActiveRecord::Migration
  def self.up
		remove_column :invoices, :client_id
  end

  def self.down
		add_column :invoices, :client_id, :integer
  end
end
