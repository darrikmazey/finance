module WorkItemsHelper
	def week_class(wi)
		"work_item_week_#{wi.start_time.to_date.cweek % 2}"
	end
end
