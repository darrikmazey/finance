class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :identifier
      t.references :client
      t.references :user
      t.datetime :billed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
