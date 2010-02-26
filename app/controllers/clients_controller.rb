class ClientsController < ApplicationController
	
	before_filter :login_required

  # GET /clients
  # GET /clients.xml
  def index
    @clients = @current_user.clients

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = @current_user.clients.find(params[:id]) rescue nil

		if @client.nil?
			redirect_to clients_url
			return
		end

		@account = @client.account

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new
		@account_parents = (@current_user.accounts.of_type(:equity).root + @current_user.accounts.of_type(:revenue)).uniq
		@client_account = RevenueAccount.new

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
		@client_accounts = @current_user.accounts
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])

		if params[:client_account]
			@client_account = RevenueAccount.new(params[:client_account])
			@client_account.name = @client.name
			@client_account.user = @current_user
			@client_account.save
			@client.account = @client_account
		end

    respond_to do |format|
      if @client.save
        flash[:notice] = 'Client was successfully created.'
        format.html { redirect_to(clients_url) }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = 'Client was successfully updated.'
        format.html { redirect_to(clients_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.xml
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end
end
