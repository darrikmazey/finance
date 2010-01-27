class AccountController < ApplicationController

	def index
		@account_type = params[:account_type]
		if @account_type
			@account_type.downcase
		end
		if @account_type == "credit"
			@accounts = Account.find :all, 
				:conditions => [ "type='client' OR type='credit'" ],
				:order => :account_name
		elsif @account_type == "expense"
			@accounts = Account.find :all, 
				:conditions => [ "type='expense' OR type='developer'" ],
				:order => :account_name
		elsif @account_type == "client"
			@accounts = Account.find :all, 
				:conditions => [ "type='client'" ],
				:order => :account_name
		elsif @account_type == "developer"
			@accounts = Account.find :all, 
				:conditions => [ "type='developer'" ],
				:order => :account_name
		else 
			@accounts = Account.find :all, 
				:order => [ :type, ", ", :account_name ]
		end
	end
		
	def view
		begin
			@account = Account.find params[:id]
		rescue ActiveRecord::RecordNotFound
			flash[:error] = 'unknown account [' + params[:id].to_s + ']'
			redirect_to :controller => 'account', :action => 'index'
			return	
		end
	end

	def edit
		if request.post?
			if params[:account][:id]
				# not a new account
				begin
					@account = Object.const_get(params[:account][:type]).find params[:account][:id]
					# if we found an account but it was still incorrect type then raise an exception 
					if @account.type.to_s != params[:account][:type]
						raise ActiveRecord::RecordNotFound
					end
				rescue ActiveRecord::RecordNotFound
					# if we can't find the record then t	he type might have changed
					# find the base and figure out what type it was before
					begin
						tester = Account.find params[:account][:id]
					rescue ActiveRecord::RecordNotFound
						flash[:error] = 'account not found [' + params[:account][:id] + ']'
						redirect_to :view => 'index'
					end

					# duplicate the account with the new type
					@account = Account.dup(tester, params[:account][:type]) 

					# delete the old account
					Account.delete(params[:account][:id])
				end
				if @account.update_attributes params[:account]
					flash[:notice] = 'account saved'
					redirect_to :action => 'view', :id => @account.id
				else 
					flash[:error] = 'failed to save account'
				end
			else
				# new account
				@account = Object.const_get(params[:account][:type]).new params[:account]
				if @account.save
					flash[:notice] = 'new account saved'
					redirect_to :action => 'view', :id => @account.id
				else 
					flash[:error] = 'failed to save new account'
				end
			end
		else
			if params[:id]
				# not a new account
				begin 
					@account = Account.find params[:id]
					@types = ['Account', 'Client', 'Credit', 'Developer', 'Expense']
				rescue ActiveRecord::RecordNotFound
					flash[:error] = 'account not found'
					redirect_to session[:previous_uri]
				end
			else
				# new account
				@account = Account.new
				@types = ['Client', 'Credit', 'Developer', 'Expense']
			end
		end	
	end
end
