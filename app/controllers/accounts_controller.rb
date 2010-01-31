class AccountsController < ApplicationController
	
	before_filter :require_user

  # GET /accounts
  # GET /accounts.xml
  def index
		if @current_user
			@accounts = @current_user.accounts.find :all, :order => ['type asc, name asc'] rescue nil
		else
			@accounts = Account.find :all, :order => ['type asc, name asc']
		end
		if params[:period]
			@period = Account::Period[params[:period].to_i]
		else
			@period = Account::Period[12]
		end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

	# POST /accounts/ajax_list
	def ajax_list
		if @current_user
			@accounts = @current_user.accounts.find :all, :order => ['type asc, name asc'] rescue nil
		else
			@accounts = Account.find :all, :order => ['type asc, name asc']
		end
		if params[:period]
			@period = Account::Period[params[:period].to_i]
		else
			@period = Account::Period[12]
		end

		render :index, :layout => false
	end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = @current_user.accounts.find(params[:id]) rescue nil
		if @account.nil?
			redirect_to accounts_url
			return
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new
		@account.user = User.first

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])
		@account.type = params[:account][:type]

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to accounts_url }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end
