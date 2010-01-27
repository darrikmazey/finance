class ChangeColumnNameFromClientIdToReferenceIdInAccounts < ActiveRecord::Migration
  def self.up
		rename_column :accounts, :client_id, :reference_id
  end

  def self.down
		rename_column :accounts, :reference_id, :client_id
  end
end
