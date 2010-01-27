class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
		t.column :account_name, :string
		t.column :account_type_id, :integer
		t.column :balance, :decimal, :precision => 8, :scale => 2
		t.column :balance_date, :datetime
		t.column :created_at, :datetime
		t.column :client_id, :integer
    end
  end

  def self.down
    drop_table :accounts
  end
end
