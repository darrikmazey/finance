class Client < ActiveRecord::Base
  belongs_to :account
	belongs_to :user
	has_many :projects
	has_many :invoices, :through => :projects

	def contact_name
    return '' unless contact_first_name && contact_last_name
		"#{contact_first_name} #{contact_last_name}"
	end

	def city_state_zip
    return '' unless contact_city && contact_state && contact_zipcode
		"#{contact_city}, #{contact_state} #{contact_zipcode}"
	end
end
