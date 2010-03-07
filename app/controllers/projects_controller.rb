class ProjectsController < ApplicationController
	
	before_filter :login_required
  before_filter :admin_account_group_required, :only => [:new, :edit, :destroy, :create, :update]

  # GET /projects
  # GET /projects.xml
  def index
    @projects = @current_user.projects_for_account_group(@user_options.account_group)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id]) rescue nil
    @project = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@project)
		if @project.nil?
			redirect_to projects_url
			return
		end
    @admins = @project.account_group.users
    @workers = @project.workers
		@account = @project.client.account
		@open_work_items = @project.work_items.open

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new
    @admins = []
    @workers = []
		@clients = @user_options.account_group.clients

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @project = nil unless @project.client.account.account_group == @user_options.account_group
    if @project.nil?
      redirect_to projects_path
      return
    end

    @admins = @project.account_group.users
    @workers = @project.workers
    @clients = @user_options.account_group.clients
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(projects_url) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(projects_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def add_project_user
    @workers = User.all
    if request.xhr?
      render :partial => 'projects/project_users/form', :locals => { :workers => @workers, :id => params[:id] }
    end
  end
end
