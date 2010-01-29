module TransactionsHelper
	def credit_account_link(trans)
		trans.credit_account ? link_to(trans.credit_account.name, account_url(trans.credit_account)) : ''
	end

	def debit_account_link(trans)
		trans.debit_account ? link_to(trans.debit_account.name, account_url(trans.debit_account)) : ''
	end
end
