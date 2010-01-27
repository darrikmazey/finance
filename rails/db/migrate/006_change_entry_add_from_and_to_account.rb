class ChangeEntryAddFromAndToAccount < ActiveRecord::Migration
  def self.up
	add_column :entries, :from_account_id, :integer
	rename_column :entries, :account_id, :to_account_id
  end

  def self.down
	remove_column :entries, :from_account_id
	rename_column :entries, :to_account_id, :account_id
  end
end
