class Client < ActiveRecord::Base
  belongs_to :account
	belongs_to :user
	has_many :invoices
	has_many :projects
end
