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
		primary_data = Array.new
		secondary_data = Array.new
		count = -1
		while d < @account.period_end
			balance_data << @account.balance_on_date(d)
			primary_data << @account.primary_on_date(d)
			secondary_data << @account.secondary_on_date(d)
			d += 1.day
			count += 1
		end
		g.data('balance', balance_data)
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
		g = Gruff::Line.new(400)
		g.title = "summary"
		d = DateTime.now - 60.days
		balance_data = Array.new
		count = 0
		while d <= DateTime.now
			balance_data << @current_user.net_balance_on_date(d)
			d += 2.days
			count += 1
		end
		g.data('balance', balance_data)
		g.hide_dots = true
		g.labels = {
			0 => d.to_s,
			(count / 2) => (d + 30.days).to_s,
			count => (d + 60.days).to_s
		}
		send_data g.to_blob, { :type => 'image/jpeg', :disposition => 'inline', :filename => 'account_summary.jpg' }
	end

end
