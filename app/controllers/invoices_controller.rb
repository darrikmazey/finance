class InvoicesController < ApplicationController
	
	before_filter :login_required
  before_filter :admin_account_group_required_redirect_root

  # GET /invoices
  # GET /invoices.xml
  def index
    if @user_options.admin_account_group?
      @invoices = @user_options.account_group.invoices
    else
      @invoices = @current_user.invoices_for_account_group(@user_options.account_group)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

	# POST /invoices/1/paid
	def paid
		@invoice = @current_user.invoices.find(params[:id]) rescue nil
		if @invoice.nil?
			redirect_to invoices_url
			return
		end

		@invoice.paid
    @invoice.bill if @invoice.billed_at.nil?
		if (@invoice.save)
			flash[:notice] = 'invoice paid.'
			redirect_to invoices_url
			return
		end
		flash[:error] = 'invoice could not be paid.'
		redirect_to invoices_url
	end

	# POST /invoices/1/unpaid
	def unpaid
		@invoice = @current_user.invoices.find(params[:id]) rescue nil
		if @invoice.nil?
			redirect_to invoices_url
			return
		end

		@invoice.unpaid
		if (@invoice.save)
			flash[:notice] = 'invoice marked unpaid.'
			redirect_to invoices_url
			return
		end
		flash[:error] = 'invoice could not be marked unpaid.'
		redirect_to invoices_url
	end

	# POST /invoices/1/bill
	def bill
		@invoice = @current_user.invoices.find(params[:id]) rescue nil
		if @invoice.nil?
			redirect_to invoices_url
			return
		end

		@invoice.bill
		if (@invoice.save)
			flash[:notice] = 'invoice billed.'
			redirect_to invoices_url
			return
		end
		flash[:error] = 'invoice could not be billed.'
		redirect_to invoices_url
	end

	# POST /invoices/1/unbill
	def unbill
		@invoice = @current_user.invoices.find(params[:id]) rescue nil
		if @invoice.nil?
			redirect_to invoices_url
			return
		end

		@invoice.unbill
		if (@invoice.save)
			flash[:notice] = 'invoice marked as not billed.'
			redirect_to invoices_url
			return
		end
		flash[:error] = 'invoice could not be marked unbilled.'
		redirect_to invoices_url
	end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])
    if @user_options.admin_account_group?
      @invoice = nil unless @user_options.account_group.invoices.include?(@invoice)
    else
      @invoice = nil unless @current_user.invoices.include?(@invoice)
    end
		if @invoice.nil?
			redirect_to invoices_url
			return
		end
		@account = @invoice.client.account

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
			format.pdf { prawnto :inline => true }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @invoice = Invoice.new
		@projects = @current_user.projects_for_account_group(@user_options.account_group)
    if @projects.empty?
      flash[:notice] = "There are currently no projects for this account group, please add one before adding an invoice."
      redirect_to new_project_path
      return
    end

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        @invoice.scoop_loose_invoice_items
        flash[:notice] = 'Invoice was successfully created.'
        format.html { redirect_to(invoices_url) }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Invoice was successfully updated.'
        format.html { redirect_to(invoices_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = @current_user.invoices.find(params[:id]) rescue nil
		if @invoice.nil?
			redirect_to invoices_url
			return
		end
		@invoice.work_items.each do |wi|
			wi.invoice = nil
			wi.save
		end
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end

	def for_project
		@invoices = Project.find(params[:id]).invoices rescue []
		if request.xhr?
			render :partial => 'invoices/invoices_for_project', :object => @invoices, :locals => { :form_class => params[:c] }
		end
	end
end
