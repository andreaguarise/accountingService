require 'test_helper'

class CloudRecordSummariesControllerTest < ActionController::TestCase
  setup do
    @cloud_record_summary = cloud_record_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cloud_record_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cloud_record_summary" do
    assert_difference('CloudRecordSummary.count') do
      post :create, :cloud_record_summary => { :cpuCount => @cloud_record_summary.cpuCount, :date => @cloud_record_summary.date, :local_group => @cloud_record_summary.local_group, :local_user => @cloud_record_summary.local_user, :memory => @cloud_record_summary.memory, :networkInBound => @cloud_record_summary.networkInBound, :networkOutBound => @cloud_record_summary.networkOutBound, :site_id => @cloud_record_summary.site_id, :vmCount => @cloud_record_summary.vmCount, :wallDuration => @cloud_record_summary.wallDuration }
    end

    assert_redirected_to cloud_record_summary_path(assigns(:cloud_record_summary))
  end

  test "should show cloud_record_summary" do
    get :show, :id => @cloud_record_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cloud_record_summary
    assert_response :success
  end

  test "should update cloud_record_summary" do
    put :update, :id => @cloud_record_summary, :cloud_record_summary => { :cpuCount => @cloud_record_summary.cpuCount, :date => @cloud_record_summary.date, :local_group => @cloud_record_summary.local_group, :local_user => @cloud_record_summary.local_user, :memory => @cloud_record_summary.memory, :networkInBound => @cloud_record_summary.networkInBound, :networkOutBound => @cloud_record_summary.networkOutBound, :site_id => @cloud_record_summary.site_id, :vmCount => @cloud_record_summary.vmCount, :wallDuration => @cloud_record_summary.wallDuration }
    assert_redirected_to cloud_record_summary_path(assigns(:cloud_record_summary))
  end

  test "should destroy cloud_record_summary" do
    assert_difference('CloudRecordSummary.count', -1) do
      delete :destroy, :id => @cloud_record_summary
    end

    assert_redirected_to cloud_record_summaries_path
  end
end
