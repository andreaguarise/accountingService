require 'test_helper'

class StorageSummariesControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @storage_summary = storage_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storage_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storage_summary" do
    assert_difference('StorageSummary.count') do
      post :create, :storage_summary => { :date => @storage_summary.date, :group => @storage_summary.group, :logicalCapacityUsed => @storage_summary.logicalCapacityUsed, :publisher_id => @storage_summary.publisher_id, :resourceCapacityUsed => @storage_summary.resourceCapacityUsed, :site => @storage_summary.site, :storageShare => @storage_summary.storageShare, :storageSystem => @storage_summary.storageSystem }
    end

    assert_redirected_to storage_summary_path(assigns(:storage_summary))
  end

  test "should show storage_summary" do
    get :show, :id => @storage_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @storage_summary
    assert_response :success
  end

  test "should update storage_summary" do
    put :update, :id => @storage_summary, :storage_summary => { :date => @storage_summary.date, :group => @storage_summary.group, :logicalCapacityUsed => @storage_summary.logicalCapacityUsed, :publisher_id => @storage_summary.publisher_id, :resourceCapacityUsed => @storage_summary.resourceCapacityUsed, :site => @storage_summary.site, :storageShare => @storage_summary.storageShare, :storageSystem => @storage_summary.storageSystem }
    assert_redirected_to storage_summary_path(assigns(:storage_summary))
  end

  test "should destroy storage_summary" do
    assert_difference('StorageSummary.count', -1) do
      delete :destroy, :id => @storage_summary
    end

    assert_redirected_to storage_summaries_path
  end
end
