class RatesController < ApplicationController

	before_filter :require_user

  # GET /rates
  # GET /rates.xml
  def index
    @rates = @current_user.rates.find(:all, :order => 'project_id asc, id asc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rates }
    end
  end

  # GET /rates/1
  # GET /rates/1.xml
  def show
    @rate = @current_user.rates.find(params[:id]) rescue nil
		if @rate.nil?
			redirect_to rates_url
			return
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rate }
    end
  end

  # GET /rates/new
  # GET /rates/new.xml
  def new
    @rate = Rate.new
    @rate.modifier = 1.00

    respond_to do |format|
      format.html { render :action => 'edit' } 
      format.xml  { render :xml => @rate }
    end
  end

  # GET /rates/1/edit
  def edit
    @rate = @current_user.rates.find(params[:id]) rescue nil
		if @rate.nil?
			redirect_to rates_url
			return
		end
  end

  # POST /rates
  # POST /rates.xml
  def create
    @rate = Rate.new(params[:rate])

    respond_to do |format|
      if @rate.save
        flash[:notice] = 'Rate was successfully created.'
        format.html { redirect_to rates_url }
        format.xml  { render :xml => @rate, :status => :created, :location => @rate }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rates/1
  # PUT /rates/1.xml
  def update
    @rate = Rate.find(params[:id])

    respond_to do |format|
      if @rate.update_attributes(params[:rate])
        flash[:notice] = 'Rate was successfully updated.'
        format.html { redirect_to rates_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1
  # DELETE /rates/1.xml
  def destroy
    @rate = Rate.find(params[:id])
    @rate.destroy

    respond_to do |format|
      format.html { redirect_to(rates_url) }
      format.xml  { head :ok }
    end
  end

	def for_project
		@rates = Project.find(params[:id]).rates rescue []
		if request.xhr?
			render :partial => 'rates/rates_for_project', :object => @rates, :locals => { :form_class => params[:c] }
		end
	end
end
