class EntryController < ApplicationController

	def index
		@account_id = params[:account_id]
		if !@account_id 
			flash[:error] = "please select an account to view their entries"
			redirect_to :controller => 'account'
		else 
			begin
				@account = Account.find @account_id
			rescue ActiveRecord::RecordNotFound
				flash[:error] = "account not found [" + @account_id.to_s + "]"
				redirect_to :controller => 'account'
			end
			@entries = Entry.find_account(@account_id)
			@total_amount = 0.00;
			@entries.each do |a|
				@total_amount += a.amount(@account_id)
			end
		end
	end

	def edit
		@accounts = Account.find :all, :order => 'type'
		if request.post?
			if params[:entry][:id]
				# not a new entry
				begin
					@entry = Entry.find params[:entry][:id]
				rescue ActiveRecord::RecordNotFound
					flash[:error] = 'entry not found [' + params[:entry][:id] + ']'
					redirect_to session[:previous_uri]
				end
				if @entry.to_account_id
					@to_account = Account.find @entry.to_account_id
				end
				if @entry.from_account_id
					@from_account = Account.find @entry.from_account_id
				end
				if @entry.update_attributes params[:entry]
					flash[:notice] = 'entry saved'
					if @entry.redirect_account
						redirect_to :action => 'index', :account_id => @entry.redirect_account
					else 
						redirect_to :controller => 'account', :action => 'index'
					end
				else
					flash[:error] = 'failed to save entry'
				end
			else
				# new entry
				@entry = Entry.new params[:entry]
				if @entry.save
					flash[:notice] = 'new entry saved'
					if @entry.redirect_account
						redirect_to :action => 'index', :account_id => @entry.redirect_account
					else 
						redirect_to :controller => 'account', :action => 'index'
					end
				else
					flash[:error] = 'failed to save new entry'
				end
			end
		else
			if params[:id]
				# not a new entry
				begin 
					@entry = Entry.find params[:id]
				rescue ActiveRecord::RecordNotFound
					flash[:error] = 'entry not found [' + params[:id] + ']'
					redirect_to session[:previous_uri]
				end
				if @entry.to_account_id
					@to_account = Account.find @entry.to_account_id
				end
				if @entry.from_account_id
					@from_account = Account.find @entry.from_account_id
				end
			else
				# new entry
				@entry = Entry.new
				@entry.date = DateTime.now
			end
		end
	end

	def delete
		if !params[:id]
			flash[:error] = 'please select an entry to delete'
		else	
			begin
				@entry = Entry.find params[:id]
			rescue ActiveRecord::RecordNotFound
				flash[:error] = 'entry not found [' + 
					@entry.id.to_s + ']'
				redirect_to session[:previous_uri]
			end
			if request.post?
				@entry.destroy
				flash[:notice] = 'entry successfully deleted'
				redirect_to :controller => 'account', :action => 'index'
			end
		end
	end
end
