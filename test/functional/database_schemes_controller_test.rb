require 'test_helper'

class DatabaseSchemesControllerTest < ActionController::TestCase
  setup do
    @database_scheme = database_schemes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:database_schemes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database_scheme" do
    assert_difference('DatabaseScheme.count') do
      post :create, :database_scheme => { :name => @database_scheme.name, :publisher_id => @database_scheme.publisher_id }
    end

    assert_redirected_to database_scheme_path(assigns(:database_scheme))
  end

  test "should show database_scheme" do
    get :show, :id => @database_scheme
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @database_scheme
    assert_response :success
  end

  test "should update database_scheme" do
    put :update, :id => @database_scheme, :database_scheme => { :name => @database_scheme.name, :publisher_id => @database_scheme.publisher_id }
    assert_redirected_to database_scheme_path(assigns(:database_scheme))
  end

  test "should destroy database_scheme" do
    assert_difference('DatabaseScheme.count', -1) do
      delete :destroy, :id => @database_scheme
    end

    assert_redirected_to database_schemes_path
  end
end
