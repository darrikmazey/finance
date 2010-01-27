class ActiveSupport::TimeWithZone
	def short_date
		self.strftime("%Y.%m.%d")
	end
end

