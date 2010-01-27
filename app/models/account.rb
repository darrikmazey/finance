class Account < ActiveRecord::Base
  belongs_to :user

	def self.model_name
		name = 'account'
		name.instance_eval do
			def plural; pluralize; end
			def singular; singularize; end
		end
		return name
	end

	def balance
		self.initial_balance
	end

	def positive?
		self.balance >= 0
	end

	def negative?
		!self.positive?
	end
end
