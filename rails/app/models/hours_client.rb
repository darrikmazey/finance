class HoursClient < HoursRecord
	has_one :billing_address, :as => :addressable
	has_many :projects

	def self.table_name
		"clients"
	end
end
