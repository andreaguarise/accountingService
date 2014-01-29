require 'test_helper'

class DatabaseRecordsControllerTest < ActionController::TestCase
  setup do
    @database_record = database_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:database_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database_record" do
    assert_difference('DatabaseRecord.count') do
      post :create, :database_record => { :database_table_id => @database_record.database_table_id, :indexsize => @database_record.indexsize, :rows => @database_record.rows, :tablesize => @database_record.tablesize, :time => @database_record.time }
    end

    assert_redirected_to database_record_path(assigns(:database_record))
  end

  test "should show database_record" do
    get :show, :id => @database_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @database_record
    assert_response :success
  end

  test "should update database_record" do
    put :update, :id => @database_record, :database_record => { :database_table_id => @database_record.database_table_id, :indexsize => @database_record.indexsize, :rows => @database_record.rows, :tablesize => @database_record.tablesize, :time => @database_record.time }
    assert_redirected_to database_record_path(assigns(:database_record))
  end

  test "should destroy database_record" do
    assert_difference('DatabaseRecord.count', -1) do
      delete :destroy, :id => @database_record
    end

    assert_redirected_to database_records_path
  end
end
