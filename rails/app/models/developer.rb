require 'account.rb'
require 'expense.rb'

class Developer < Expense

	def hours_developer
		self.reference_object
	end
end
