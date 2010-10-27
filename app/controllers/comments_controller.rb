class CommentsController < ApplicationController
	
	before_filter :login_required
  before_filter :load_work_item

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
		if @work_item
			@comment.work_item = @work_item
		end

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.xml  { render :xml => @comment }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to invoice_items_url }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment.work_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end

  private

  # load the comment and work item
  # fail gracefully if there is an issue and make sure the project for the work item is viewable
  def load_work_item
    @work_item = WorkItem.find(params[:work_item_id]) if params[:work_item_id]
    @work_item = WorkItem.find(params[:comment][:work_item_id]) if params[:comment]
    if params[:id] 
      @comment = Comment.find(params[:id]) rescue nil
      @work_item = @comment.work_item rescue nil
    end
    @work_item = nil unless @current_user.projects_for_account_group(@user_options.account_group).include?(@work_item.project) rescue nil
    redirect_to work_items_path if @work_item.nil?
  end
end
