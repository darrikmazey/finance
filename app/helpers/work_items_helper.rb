module WorkItemsHelper
	def week_class(wi)
		if Date.today.cweek == wi.start_time.to_date.cweek
			"work_item_week_this"
		else
			"work_item_week_#{wi.start_time.to_date.cweek % 2}"
		end
	end
end
