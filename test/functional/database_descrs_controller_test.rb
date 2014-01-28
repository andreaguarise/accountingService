require 'test_helper'

class DatabaseDescrsControllerTest < ActionController::TestCase
  setup do
    @database_descr = database_descrs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:database_descrs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database_descr" do
    assert_difference('DatabaseDescr.count') do
      post :create, :database_descr => { :backend => @database_descr.backend, :backendVersion => @database_descr.backendVersion, :database_scheme_id => @database_descr.database_scheme_id }
    end

    assert_redirected_to database_descr_path(assigns(:database_descr))
  end

  test "should show database_descr" do
    get :show, :id => @database_descr
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @database_descr
    assert_response :success
  end

  test "should update database_descr" do
    put :update, :id => @database_descr, :database_descr => { :backend => @database_descr.backend, :backendVersion => @database_descr.backendVersion, :database_scheme_id => @database_descr.database_scheme_id }
    assert_redirected_to database_descr_path(assigns(:database_descr))
  end

  test "should destroy database_descr" do
    assert_difference('DatabaseDescr.count', -1) do
      delete :destroy, :id => @database_descr
    end

    assert_redirected_to database_descrs_path
  end
end
