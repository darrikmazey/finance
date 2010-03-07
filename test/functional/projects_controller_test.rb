require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  def setup
    login_as :ag_1_admin
  end

  ## Standard tests 

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)

    # admin should see all projects for account group
    assert assigns(:projects).include?(projects(:ag_1_project_1))
    assert assigns(:projects).include?(projects(:ag_1_project_2))

    # admin should not see proejcts for different account group
    assert !assigns(:projects).include?(projects(:ag_2_project_1))
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    use_account_group :account_group_1
    assert_difference('Project.count') do
      post :create, :project => { :name => 'new_project', :description => 'test new client', :client_id => clients(:ag_1_client_1).id }
    end

    project = Project.find(:first, :conditions => { :name => 'new_project' })
    assert_equal project.client.account.account_group, account_groups(:account_group_1)
    assert_redirected_to projects_path
    assert_equal 'Project was successfully created.', flash[:notice]
  end

  test "should show project" do
    get :show, :id => projects(:ag_1_project_1).id
    assert_response :success
  end
  
  test "admin should not show wrong account group project" do
    get :show, :id => projects(:ag_2_project_1).id
    assert_redirected_to projects_path
  end

  test "should get edit" do
    get :edit, :id => projects(:ag_1_project_1).to_param
    assert_response :success
  end

  test "admin should not edit wrong account group project" do
    get :edit, :id => projects(:ag_2_project_1).to_param
    assert_redirected_to projects_path
  end

  test "should update project" do
    put :update, :id => projects(:ag_1_project_1).to_param, :project => { }
    assert_redirected_to projects_path
  end

  test "admin should not update wrong account group project" do
    put :update, :id => projects(:ag_2_project_1).to_param, :project => { :name => "updated_name" }
    project = projects(:ag_2_project_1)
    assert_not_equal project.name, "updated_name"
    assert_redirected_to projects_path
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:ag_1_project_1).to_param
    end

    assert_redirected_to projects_path
  end

  ## Fail tests for wrong client group

  test "should redirect on show project using bad client group" do
    use_account_group :account_group_2
    get :show, :id => projects(:ag_1_project_1).id
    assert_redirected_to projects_path
  end

  test "should redirect on edit project using bad client group" do
    use_account_group :account_group_2
    get :edit, :id => projects(:ag_1_project_1).to_param
    assert_redirected_to projects_path
  end

  test "should redirect on destroy project using bad client group" do
    use_account_group :account_group_2
    delete :destroy, :id => projects(:ag_1_project_1).to_param
    assert_redirected_to projects_path
  end

  ## Fail tests for worker

  test "should get index for worker" do
    login_as :ag_1_worker
    get :index
    assert_response :success
    assert assigns(:projects)
    assert assigns(:projects).include?(projects(:ag_1_project_1))
    assert !assigns(:projects).include?(projects(:ag_1_project_2))
    assert !assigns(:projects).include?(projects(:ag_2_project_1))
  end

  test "should fail on get new for worker" do
    login_as :ag_1_worker
    get :new
    assert_redirected_to projects_path
  end

  test "should fail on create project for worker" do
    login_as :ag_1_worker
    use_account_group :account_group_1
    assert_no_difference('Project.count') do
      post :create, :project => { :name => 'new_project', :description => 'test new client', :client_id => clients(:ag_1_client_1) }
    end

    project = Project.find(:first, :conditions => { :name => 'new_project' })
    assert_nil project
    assert_redirected_to projects_path
    assert_equal admin_account_group_error, flash[:error]
  end

  test "should show project for worker" do
    login_as :ag_1_worker
    get :show, :id => projects(:ag_1_project_1).id
    assert_response :success
  end

  test "should rails on show wrong project for worker" do
    login_as :ag_1_worker
    get :show, :id => projects(:ag_1_project_2).id
    assert_redirected_to projects_path
  end

  test "should fail on get edit for worker" do
    login_as :ag_1_worker
    get :edit, :id => projects(:ag_1_project_1).to_param
    assert_redirected_to projects_path
  end

  test "should fail on update project for worker" do
    login_as :ag_1_worker
    put :update, :id => projects(:ag_1_project_1).to_param, :client => { }
    assert_redirected_to projects_path
  end

  test "should fail on destroy project for worker" do
    login_as :ag_1_worker
    assert_no_difference('Project.count', -1) do
      delete :destroy, :id => projects(:ag_1_project_1).to_param
    end

    assert_redirected_to projects_path
  end

end
