require 'test_helper'

class StorageSummaryTwosControllerTest < ActionController::TestCase
  setup do
    @storage_summary_two = storage_summary_twos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storage_summary_twos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storage_summary_two" do
    assert_difference('StorageSummaryTwo.count') do
      post :create, :storage_summary_two => { :date => @storage_summary_two.date, :group => @storage_summary_two.group, :logicalCapacityUsed => @storage_summary_two.logicalCapacityUsed, :publisher_id => @storage_summary_two.publisher_id, :resourceCapacityUsed => @storage_summary_two.resourceCapacityUsed, :site => @storage_summary_two.site, :storageClass => @storage_summary_two.storageClass, :storageSystem => @storage_summary_two.storageSystem }
    end

    assert_redirected_to storage_summary_two_path(assigns(:storage_summary_two))
  end

  test "should show storage_summary_two" do
    get :show, :id => @storage_summary_two
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @storage_summary_two
    assert_response :success
  end

  test "should update storage_summary_two" do
    put :update, :id => @storage_summary_two, :storage_summary_two => { :date => @storage_summary_two.date, :group => @storage_summary_two.group, :logicalCapacityUsed => @storage_summary_two.logicalCapacityUsed, :publisher_id => @storage_summary_two.publisher_id, :resourceCapacityUsed => @storage_summary_two.resourceCapacityUsed, :site => @storage_summary_two.site, :storageClass => @storage_summary_two.storageClass, :storageSystem => @storage_summary_two.storageSystem }
    assert_redirected_to storage_summary_two_path(assigns(:storage_summary_two))
  end

  test "should destroy storage_summary_two" do
    assert_difference('StorageSummaryTwo.count', -1) do
      delete :destroy, :id => @storage_summary_two
    end

    assert_redirected_to storage_summary_twos_path
  end
end
