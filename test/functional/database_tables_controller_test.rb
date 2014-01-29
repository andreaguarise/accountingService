require 'test_helper'

class DatabaseTablesControllerTest < ActionController::TestCase
  setup do
    @database_table = database_tables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:database_tables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database_table" do
    assert_difference('DatabaseTable.count') do
      post :create, :database_table => { :database_scheme_id => @database_table.database_scheme_id, :name => @database_table.name }
    end

    assert_redirected_to database_table_path(assigns(:database_table))
  end

  test "should show database_table" do
    get :show, :id => @database_table
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @database_table
    assert_response :success
  end

  test "should update database_table" do
    put :update, :id => @database_table, :database_table => { :database_scheme_id => @database_table.database_scheme_id, :name => @database_table.name }
    assert_redirected_to database_table_path(assigns(:database_table))
  end

  test "should destroy database_table" do
    assert_difference('DatabaseTable.count', -1) do
      delete :destroy, :id => @database_table
    end

    assert_redirected_to database_tables_path
  end
end
