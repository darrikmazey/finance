class TransactionsController < ApplicationController

	before_filter :login_required
  before_filter :admin_account_group_required_redirect_root

  # GET /transactions
  # GET /transactions.xml
  def index
		if @account.nil?
			@transactions = Transaction.all_for_account_group(@user_options.account_group)
			#@transactions = Transaction.find :all, :conditions => ['credit_account_id in (select id from accounts where user_id = ?) or debit_account_id in (select id from accounts where user_id = ?)', @current_user.id, @current_user.id], :order => ['trans_date desc, id desc']
		else
			@transactions = @account.transactions.find :all, :order => ['trans_date desc, id desc']
		end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = Transaction.new

		ttype = params[:type]
		@accounts = @user_options.account_group.accounts
    if @accounts.empty?
      flash[:notice] = "There are currently no accounts for this account group, please add one before adding a transaction."
      redirect_to new_account_path
      return
    end

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])
		@account = Account.find(params[:account][:id]) rescue nil

    respond_to do |format|
      if @transaction.save
        flash[:notice] = 'Transaction was successfully created.'
        format.html { @account ? redirect_to(@account) : redirect_to(transactions_path) }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        flash[:notice] = 'Transaction was successfully updated.'
        format.html { redirect_to(transactions_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end
end
