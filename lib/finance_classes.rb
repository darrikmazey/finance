class ActiveSupport::TimeWithZone
	def short_date
		self.strftime("%Y.%m.%d")
	end
end

class DateTime
	def short_date
		self.strftime("%Y.%m.%d")
	end
end

