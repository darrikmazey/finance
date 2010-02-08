class InvoicesController < ApplicationController
	
	before_filter :require_user

  # GET /invoices
  # GET /invoices.xml
  def index
    @invoices = @current_user.invoices

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
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
    @invoice = @current_user.invoices.find(params[:id]) rescue nil
		if @invoice.nil?
			redirect_to invoices_url
			return
		end
		@account = @invoice.client.account

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @invoice = Invoice.new
		@projects = @current_user.projects

    respond_to do |format|
      format.html # new.html.erb
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
        flash[:notice] = 'Invoice was successfully created.'
        format.html { redirect_to(@invoice) }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
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
        format.html { redirect_to(@invoice) }
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
    @invoice = Invoice.find(params[:id])
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
