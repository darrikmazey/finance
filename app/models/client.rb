class Client < ActiveRecord::Base
  belongs_to :client_account
	belongs_to :user
	has_many :invoices
	has_many :projects
end
