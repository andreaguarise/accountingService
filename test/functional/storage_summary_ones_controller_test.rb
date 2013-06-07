require 'test_helper'

class StorageSummaryOnesControllerTest < ActionController::TestCase
  setup do
    @storage_summary_one = storage_summary_ones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storage_summary_ones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storage_summary_one" do
    assert_difference('StorageSummaryOne.count') do
      post :create, :storage_summary_one => { :date => @storage_summary_one.date, :logicalCapacityUsed => @storage_summary_one.logicalCapacityUsed, :publisher_id => @storage_summary_one.publisher_id, :resourceCapacityAllocated => @storage_summary_one.resourceCapacityAllocated, :resourceCapacityUsed => @storage_summary_one.resourceCapacityUsed, :site => @storage_summary_one.site, :storageClass => @storage_summary_one.storageClass, :storageSystem => @storage_summary_one.storageSystem }
    end

    assert_redirected_to storage_summary_one_path(assigns(:storage_summary_one))
  end

  test "should show storage_summary_one" do
    get :show, :id => @storage_summary_one
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @storage_summary_one
    assert_response :success
  end

  test "should update storage_summary_one" do
    put :update, :id => @storage_summary_one, :storage_summary_one => { :date => @storage_summary_one.date, :logicalCapacityUsed => @storage_summary_one.logicalCapacityUsed, :publisher_id => @storage_summary_one.publisher_id, :resourceCapacityAllocated => @storage_summary_one.resourceCapacityAllocated, :resourceCapacityUsed => @storage_summary_one.resourceCapacityUsed, :site => @storage_summary_one.site, :storageClass => @storage_summary_one.storageClass, :storageSystem => @storage_summary_one.storageSystem }
    assert_redirected_to storage_summary_one_path(assigns(:storage_summary_one))
  end

  test "should destroy storage_summary_one" do
    assert_difference('StorageSummaryOne.count', -1) do
      delete :destroy, :id => @storage_summary_one
    end

    assert_redirected_to storage_summary_ones_path
  end
end
