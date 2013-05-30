require 'test_helper'

class LocalCpuRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @local_cpu_record = batch_execute_records(:batch_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:local_cpu_records)
  end

  test "should show local_cpu_record" do
    get :show, :id => @local_cpu_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @local_cpu_record
    assert_response :success
  end

  test "should update local_cpu_record" do
    put :update, :id => @local_cpu_record, :local_cpu_record => { :lrmsId => @local_cpu_record.lrmsId }
    assert_redirected_to local_cpu_record_path(assigns(:local_cpu_record))
  end

  test "should destroy local_cpu_record" do
    assert_difference('LocalCpuRecord.count', -1) do
      delete :destroy, :id => @local_cpu_record
    end

    assert_redirected_to local_cpu_records_path
  end
end
