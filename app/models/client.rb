class Client < ActiveRecord::Base
  belongs_to :client_account
	belongs_to :user
end
