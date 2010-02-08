class Client < ActiveRecord::Base
  belongs_to :account
	belongs_to :user
	has_many :projects
	has_many :invoices, :through => :projects
end
