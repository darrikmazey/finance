class WorkItemsController < ApplicationController

	before_filter :require_user

  # GET /work_items
  # GET /work_items.xml
  def index
		@list_type = :loose
    @work_items = @current_user.work_items.loose.ascending_creation

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @work_items }
    end
  end

	def all
		@list_type = :all
		@work_items = @current_user.work_items.ascending_creation

		respond_to do |format|
			format.html { render :action => :index }
			format.xml { render :xml => @work_items }
		end
	end

  # GET /work_items/1
  # GET /work_items/1.xml
  def show
    @work_item = @current_user.work_items.find(params[:id]) rescue nil
		if @work_item.nil?
			redirect_to work_items_url
			return
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @work_item }
    end
  end

	# POST /work_items/1/close
	def close
		@work_item = @current_user.work_items.find(params[:id]) rescue nil
		if @work_item.nil?
			redirect_to work_items_url
			return
		end
		
		@work_item.close
		if (@work_item.save)
			flash[:notice] = 'work item closed.'
			redirect_to work_items_url
			return
		end
		flash[:error] = 'work item could not be closed'
		redirect_to work_items_url
	end

	# POST /work_items/1/open
	def open
		@work_item = @current_user.work_items.find(params[:id]) rescue nil
		if @work_item.nil?
			redirect_to work_items_url
			return
		end
		@work_item.open
		if (@work_item.save)
			flash[:notice] = 'work item opened.'
			redirect_to work_items_url
			return
		end
		flash[:error] = 'work item could not be opened.'
		redirect_to work_items_url
	end

  # GET /work_items/new
  # GET /work_items/new.xml
  def new
    @work_item = WorkItem.new
		@work_item.user = @current_user
		@work_item.start_time = DateTime.now
		@work_item.align_start_time
		@work_item.project = @current_user.last_project || @current_user.projects.first
		@work_item.rate = @current_user.last_rate || @work_item.project.rates.first

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work_item }
    end
  end

  # GET /work_items/1/edit
  def edit
    @work_item = @current_user.work_items.find(params[:id]) rescue nil
		if @work_item.nil?
			redirect_to work_items_url
			return
		end
  end

  # POST /work_items
  # POST /work_items.xml
  def create
    @work_item = WorkItem.new(params[:work_item])

    respond_to do |format|
      if @work_item.save
        flash[:notice] = 'WorkItem was successfully created.'
        format.html { redirect_to work_items_url }
        format.xml  { render :xml => @work_item, :status => :created, :location => @work_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @work_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /work_items/1
  # PUT /work_items/1.xml
  def update
    @work_item = WorkItem.find(params[:id])

    respond_to do |format|
      if @work_item.update_attributes(params[:work_item])
        flash[:notice] = 'WorkItem was successfully updated.'
        format.html { redirect_to(@work_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @work_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /work_items/1
  # DELETE /work_items/1.xml
  def destroy
    @work_item = WorkItem.find(params[:id])
    @work_item.destroy

    respond_to do |format|
      format.html { redirect_to(work_items_url) }
      format.xml  { head :ok }
    end
  end
end
