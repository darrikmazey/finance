class AddContactInformationToClients < ActiveRecord::Migration
  def self.up
		add_column :clients, :contact_first_name, :string
		add_column :clients, :contact_last_name, :string
		add_column :clients, :contact_street1, :string
		add_column :clients, :contact_street2, :string
		add_column :clients, :contact_city, :string
		add_column :clients, :contact_state, :string
		add_column :clients, :contact_zipcode, :string
  end

  def self.down
		remove_column :clients, :contact_zipcode
		remove_column :clients, :contact_state
		remove_column :clients, :contact_city
		remove_column :clients, :contact_street2
		remove_column :clients, :contact_street1
		remove_column :clients, :contact_last_name
		remove_column :clients, :contact_first_name
  end
end
