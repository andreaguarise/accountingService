require 'test_helper'

class CloudViewVmSummariesControllerTest < ActionController::TestCase
  setup do
    @cloud_view_vm_summary = cloud_view_vm_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cloud_view_vm_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cloud_view_vm_summary" do
    assert_difference('CloudViewVmSummary.count') do
      post :create, :cloud_view_vm_summary => { :VMUUID => @cloud_view_vm_summary.VMUUID, :cloudType => @cloud_view_vm_summary.cloudType, :cpuCount => @cloud_view_vm_summary.cpuCount, :cpuDuration => @cloud_view_vm_summary.cpuDuration, :date => @cloud_view_vm_summary.date, :disk => @cloud_view_vm_summary.disk, :diskImage => @cloud_view_vm_summary.diskImage, :localVMID => @cloud_view_vm_summary.localVMID, :local_group => @cloud_view_vm_summary.local_group, :local_user => @cloud_view_vm_summary.local_user, :memory => @cloud_view_vm_summary.memory, :networkInbound => @cloud_view_vm_summary.networkInbound, :networkOutbound => @cloud_view_vm_summary.networkOutbound, :publisher_id => @cloud_view_vm_summary.publisher_id, :status => @cloud_view_vm_summary.status, :vmCount => @cloud_view_vm_summary.vmCount, :wallDuration => @cloud_view_vm_summary.wallDuration }
    end

    assert_redirected_to cloud_view_vm_summary_path(assigns(:cloud_view_vm_summary))
  end

  test "should show cloud_view_vm_summary" do
    get :show, :id => @cloud_view_vm_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cloud_view_vm_summary
    assert_response :success
  end

  test "should update cloud_view_vm_summary" do
    put :update, :id => @cloud_view_vm_summary, :cloud_view_vm_summary => { :VMUUID => @cloud_view_vm_summary.VMUUID, :cloudType => @cloud_view_vm_summary.cloudType, :cpuCount => @cloud_view_vm_summary.cpuCount, :cpuDuration => @cloud_view_vm_summary.cpuDuration, :date => @cloud_view_vm_summary.date, :disk => @cloud_view_vm_summary.disk, :diskImage => @cloud_view_vm_summary.diskImage, :localVMID => @cloud_view_vm_summary.localVMID, :local_group => @cloud_view_vm_summary.local_group, :local_user => @cloud_view_vm_summary.local_user, :memory => @cloud_view_vm_summary.memory, :networkInbound => @cloud_view_vm_summary.networkInbound, :networkOutbound => @cloud_view_vm_summary.networkOutbound, :publisher_id => @cloud_view_vm_summary.publisher_id, :status => @cloud_view_vm_summary.status, :vmCount => @cloud_view_vm_summary.vmCount, :wallDuration => @cloud_view_vm_summary.wallDuration }
    assert_redirected_to cloud_view_vm_summary_path(assigns(:cloud_view_vm_summary))
  end

  test "should destroy cloud_view_vm_summary" do
    assert_difference('CloudViewVmSummary.count', -1) do
      delete :destroy, :id => @cloud_view_vm_summary
    end

    assert_redirected_to cloud_view_vm_summaries_path
  end
end
