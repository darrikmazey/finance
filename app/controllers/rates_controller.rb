class RatesController < ApplicationController

	before_filter :login_required
  before_filter :admin_account_group_required_redirect_root

  # GET /rates
  # GET /rates.xml
  def index
    projects = @current_user.projects_for_account_group(@user_options.account_group)
    @rates = projects.collect { |pro| pro.rates }.flatten

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rates }
    end
  end

  # GET /rates/1
  # GET /rates/1.xml
  def show
    @rate = Rate.find(params[:id])
    if @rate
      @rate = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@rate.project)
    end
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
    @projects = @current_user.projects_for_account_group(@user_options.account_group)

    respond_to do |format|
      format.html { render :action => 'edit' } 
      format.xml  { render :xml => @rate }
    end
  end

  # GET /rates/1/edit
  def edit
    @rate = Rate.find(params[:id])
    if @rate
      @rate = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@rate.project)
    end
		if @rate.nil?
			redirect_to rates_url
			return
		end
    @projects = @current_user.projects_for_account_group(@user_options.account_group)
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
    if @rate
      @rate = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@rate.project)
    end
		if @rate.nil?
			redirect_to rates_url
			return
		end

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
    if @rate
      @rate = nil unless @user_options.admin_account_group?
    end
		if @rate.nil?
			redirect_to rates_url
			return
		end
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
