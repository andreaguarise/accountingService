require 'test_helper'

class DatabaseRecordSummariesControllerTest < ActionController::TestCase
  setup do
    @database_record_summary = database_record_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:database_record_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database_record_summary" do
    assert_difference('DatabaseRecordSummary.count') do
      post :create, :database_record_summary => { :database_descr_id => @database_record_summary.database_descr_id, :indexsize => @database_record_summary.indexsize, :publisher_id => @database_record_summary.publisher_id, :record_date => @database_record_summary.record_date, :rows => @database_record_summary.rows, :scheme_name => @database_record_summary.scheme_name, :table_name => @database_record_summary.table_name, :tablesize => @database_record_summary.tablesize }
    end

    assert_redirected_to database_record_summary_path(assigns(:database_record_summary))
  end

  test "should show database_record_summary" do
    get :show, :id => @database_record_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @database_record_summary
    assert_response :success
  end

  test "should update database_record_summary" do
    put :update, :id => @database_record_summary, :database_record_summary => { :database_descr_id => @database_record_summary.database_descr_id, :indexsize => @database_record_summary.indexsize, :publisher_id => @database_record_summary.publisher_id, :record_date => @database_record_summary.record_date, :rows => @database_record_summary.rows, :scheme_name => @database_record_summary.scheme_name, :table_name => @database_record_summary.table_name, :tablesize => @database_record_summary.tablesize }
    assert_redirected_to database_record_summary_path(assigns(:database_record_summary))
  end

  test "should destroy database_record_summary" do
    assert_difference('DatabaseRecordSummary.count', -1) do
      delete :destroy, :id => @database_record_summary
    end

    assert_redirected_to database_record_summaries_path
  end
end
