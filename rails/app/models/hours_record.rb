class HoursRecord < ActiveRecord::Base
	self.abstract_class = true
	establish_connection "hours"
end
