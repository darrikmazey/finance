class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
	t.column :account_id, :integer
	t.column :text, :string
	t.column :amount, :decimal, :precision => 8, :scale => 2
	t.column :description, :string
	t.column :invoice_id, :integer
	t.column :date, :datetime
    end
  end

  def self.down
    drop_table :entries
  end
end
