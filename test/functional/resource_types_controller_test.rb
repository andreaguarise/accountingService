require 'test_helper'

class ResourceTypesControllerTest < ActionController::TestCase
  setup do
    login_as :scrocco if defined? session
    @resource_type = resource_types(:one)
    @resource_type.name = "newUniqueName"
    @resource_type_two = resource_types(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resource_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource_type" do
    assert_difference('ResourceType.count') do
      post :create, :resource_type => { :name => @resource_type.name }
    end

    assert_redirected_to resource_type_path(assigns(:resource_type))
  end
  
  test "should fail to create resource_type whit non unique name" do
    assert_no_difference('ResourceType.count') do
      post :create, :resource_type => { :name => @resource_type_two.name }
    end
  end

  test "should show resource_type" do
    get :show, :id => @resource_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @resource_type
    assert_response :success
  end

  test "should update resource_type" do
    put :update, :id => @resource_type, :resource_type => { :name => @resource_type.name }
    assert_redirected_to resource_type_path(assigns(:resource_type))
  end

  test "should destroy resource_type" do
    assert_difference('ResourceType.count', -1) do
      delete :destroy, :id => @resource_type
    end

    assert_redirected_to resource_types_path
  end
end
