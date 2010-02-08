class ActiveSupport::TimeWithZone
	def short_date
		self.strftime("%Y.%m.%d")
	end

	def short_date_time
		self.strftime("%Y.%m.%d %H:%M")
	end

	def short_time
		self.strftime("%H:%M")
	end
end

class DateTime
	def short_date
		self.strftime("%Y.%m.%d")
	end

	def short_date_time
		self.strftime("%Y.%m.%d %H:%M")
	end

	def short_time
		self.strftime("%H:%M")
	end
end

