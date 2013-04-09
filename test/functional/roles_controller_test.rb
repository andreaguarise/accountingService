require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup do
    login_as :scrocco if defined? session
    @role = roles(:one)
    @role3 = roles(:three)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create role" do
    assert_difference('Role.count') do
      post :create, :role => { :description => @role.description, :name => @role.name }
    end

    assert_redirected_to role_path(assigns(:role))
  end

  test "should show role" do
    get :show, :id => @role
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @role
    assert_response :success
  end

  test "should update role" do
    put :update, :id => @role, :role => { :description => @role.description, :name => @role.name }
    assert_redirected_to role_path(assigns(:role))
  end

  test "should destroy role" do
    assert_difference('Role.count', -1) do
      delete :destroy, :id => @role3
    end
    assert_redirected_to roles_path
  end
  
  test "should not destroy admin role" do
    assert_difference('Role.count', 0) do
      delete :destroy, :id => @role
    end
    assert_redirected_to roles_path
  end
  
end
