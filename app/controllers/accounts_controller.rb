class AccountsController < ApplicationController
	
  before_filter :login_required
  before_filter { |c| c.send :admin_account_group_required, '/' }

  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = @user_options.account_group.accounts.root
		if params[:period]
			@period = Period[params[:period].to_i]
		else
			@period = Period[12]
		end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

	def ajax_index
		@accounts = @current_user.accounts.root

		render :layout => false
	end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = @current_user.accounts.find(params[:id]) rescue nil
    @account = nil unless @account.account_group == @user_options.account_group
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
		@parents = @current_user.accounts

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = @current_user.accounts.find(params[:id]) rescue nil
    @account = nil unless @account.account_group == @user_options.account_group
		if @account.nil?
			redirect_to accounts_url
			return
		end
		@parents = @current_user.accounts
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])
    @account.account_group = @user_options.account_group
		@account.type = params[:account][:type]
		@account.save

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to(accounts_url) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "edit" }
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
        format.html { redirect_to(accounts_url) }
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
    @account = nil unless @account.account_group == @user_options.account_group
    if @account.nil?
      redirect_to accounts_path
      return
    end
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end
