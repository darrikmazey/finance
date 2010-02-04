require 'rubygems'
require 'gruff'

class GraphsController < ApplicationController

	def account
		@account = Account.find params[:id] rescue nil

#		g = Gruff::Bar.new(400)
#		g.title = "account summary (#{@account.name})"
#		d = @account.period_start(1)
#		g.data('balance', [
#			@account.balance_on_date(@account.period_start(1)),
#			@account.balance_on_date(@account.period_start(1) + Account::Period[@account.period].delta / 2),
#			@account.balance_on_date(@account.period_start),
#			@account.balance_on_date(@account.period_start + Account::Period[@account.period].delta / 2),
#			@account.balance_on_date(@account.period_end)])
#		g.labels = {
#			0 => @account.period_start(1).short_date,
#			1 => (@account.period_start(1) + Account::Period[@account.period].delta / 2).short_date,
#			2 => @account.period_start.short_date,
#			3 => (@account.period_start + Account::Period[@account.period].delta / 2).short_date,
#			4 => @account.period_end.short_date }
#		send_data g.to_blob, { :type => 'image/jpeg', :disposition => 'inline', :filename => 'account_summary.jpg' }
#		return
		
		g = Gruff::Line.new(400)
		g.title = "account summary (#{@account.name})"
		d = @account.period_start(1)
		balance_data = Array.new
		unalloc_data = Array.new
		primary_data = Array.new
		secondary_data = Array.new
		count = -1
		while d < @account.period_end
			balance_data << @account.real_balance_on_date(d)
			unalloc_data << @account.perceived_balance_on_date(d)
			primary_data << @account.primary_on_date(d)
			secondary_data << @account.secondary_on_date(d)
			d += 1.day
			count += 1
		end
		g.data('balance', balance_data)
		g.data('unallocated', unalloc_data)
		if @account.is_credit_account?
			g.data('credits', primary_data)
			g.data('debits', secondary_data)
		else
			g.data('credits', secondary_data)
			g.data('debits', primary_data)
		end
		g.baseline_value = @account.amount
		g.baseline_color = '#991111'
		g.hide_dots = true
		g.labels = { 0 => @account.period_start(1).short_date, (count / 2) => @account.period_start.short_date, count => @account.period_end.short_date }
		send_data g.to_blob, { :type => 'image/jpeg', :disposition => 'inline', :filename => 'account_summary.jpg' }
	end

	def summary
		g = Gruff::Line.new(800)
		g.title = "summary"
		e = d = DateTime.now.utc - 60.days
		balance_data = Array.new
		credit_data = Array.new
		debit_data = Array.new
		count = -1
		while d <= DateTime.now.utc
			balance_data << @current_user.net_balance_on_date(d)
		#	credit_data << @current_user.credit_balance_sans_client_on_date(d)
		#	debit_data << @current_user.debit_balance_on_date(d)
			d += 2.days
			count += 1
		end
		g.data('balance', balance_data)
		#g.data('credit', credit_data)
		#g.data('debit', debit_data)
		g.hide_dots = true
		g.labels = {
			0 => e.short_date,
			(count / 2) => (e + 30.days).short_date,
			count => (e + 60.days).short_date
		}
		send_data g.to_blob, { :type => 'image/jpeg', :disposition => 'inline', :filename => 'account_summary.jpg' }
	end

end
