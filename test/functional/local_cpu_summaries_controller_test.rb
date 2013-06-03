require 'test_helper'

class LocalCpuSummariesControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @local_cpu_summary = local_cpu_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:local_cpu_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create local_cpu_summary" do
    assert_difference('LocalCpuSummary.count') do
      post :create, :local_cpu_summary => { :date => @local_cpu_summary.date, :localGroup => @local_cpu_summary.localGroup, :localUser => @local_cpu_summary.localUser, :publisher_id => @local_cpu_summary.publisher_id, :queue => @local_cpu_summary.queue, :totalCpuT => @local_cpu_summary.totalCpuT, :totalRecords => @local_cpu_summary.totalRecords, :totalWallT => @local_cpu_summary.totalWallT }
    end

    assert_redirected_to local_cpu_summary_path(assigns(:local_cpu_summary))
  end

  test "should show local_cpu_summary" do
    get :show, :id => @local_cpu_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @local_cpu_summary
    assert_response :success
  end

  test "should update local_cpu_summary" do
    put :update, :id => @local_cpu_summary, :local_cpu_summary => { :date => @local_cpu_summary.date, :localGroup => @local_cpu_summary.localGroup, :localUser => @local_cpu_summary.localUser, :publisher_id => @local_cpu_summary.publisher_id, :queue => @local_cpu_summary.queue, :totalCpuT => @local_cpu_summary.totalCpuT, :totalRecords => @local_cpu_summary.totalRecords, :totalWallT => @local_cpu_summary.totalWallT }
    assert_redirected_to local_cpu_summary_path(assigns(:local_cpu_summary))
  end

  test "should destroy local_cpu_summary" do
    assert_difference('LocalCpuSummary.count', -1) do
      delete :destroy, :id => @local_cpu_summary
    end

    assert_redirected_to local_cpu_summaries_path
  end
end
