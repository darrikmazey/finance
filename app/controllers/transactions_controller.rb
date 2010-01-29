class TransactionsController < ApplicationController

	before_filter :require_user

  # GET /transactions
  # GET /transactions.xml
  def index
		if @account.nil?
			@transactions = Transaction.find :all, :order => ['trans_date desc, id desc']
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
		if @account
			if ttype == 'transfer'
				if @account.is_debit_account?
					@debit_accounts = Account.all_debit
					@credit_accounts = Account.all_debit
					@transaction.credit_account = @account
					@transaction.description = 'transfer'
				else
					@debit_accounts = Account.all_credit
					@credit_accounts = Account.all_credit
					@transaction.debit_account = @account
					@transaction.description = 'transfer'
				end
			else
				if (ttype == 'debit' and @account.is_debit_account?) or (ttype == 'credit' and @account.is_credit_account?)
					@debit_accounts = Account.all_debit
					@credit_accounts = Account.all_credit
				else
					@debit_accounts = Account.all_credit
					@credit_accounts = Account.all_debit
				end
				if ttype == 'debit'
					@transaction.debit_account = @account
				else
					@transaction.credit_account = @account
				end
			end
		else
			@debit_accounts = Account.all
			@credit_accounts = Account.all
		end

    respond_to do |format|
      format.html # new.html.erb
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
        format.html { @account ? redirect_to(@account) : redirect_to(@transaction) }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
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
        format.html { redirect_to(@transaction) }
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
