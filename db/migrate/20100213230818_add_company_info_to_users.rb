class AddCompanyInfoToUsers < ActiveRecord::Migration
  def self.up
		add_column :users, :company_name, :string
		add_column :users, :company_street1, :string
		add_column :users, :company_street2, :string
		add_column :users, :company_city, :string
		add_column :users, :company_state, :string
		add_column :users, :company_zipcode, :string
		add_column :users, :company_phone, :string
  end

  def self.down
		remove_column :users, :company_phone
		remove_column :users, :company_zipcode
		remove_column :users, :company_state
		remove_column :users, :company_city
		remove_column :users, :company_street2
		remove_column :users, :company_street1
		remove_column :users, :company_name
  end
end
