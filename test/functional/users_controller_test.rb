require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    login_as :scrocco if defined? session
    @input_attributes = {
      :name => "casco",
      :password => "ludicrous",
      :password => "ludicrous"
    }
    @role = roles(:one)
    @user = users(:scrocco)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @input_attributes, 'role_name' => @role.name
    end

    assert_redirected_to users_path
  end

  test "should show user" do
    get :show, :id => @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @input_attributes
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user
    end

    assert_redirected_to users_path
  end
end
