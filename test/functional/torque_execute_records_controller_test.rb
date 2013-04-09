require 'test_helper'

class TorqueExecuteRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @torque_execute_record = torque_execute_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:torque_execute_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create torque_execute_record" do
    assert_difference('TorqueExecuteRecord.count') do
      post :create, :torque_execute_record => { :ctime => @torque_execute_record.ctime, :end => @torque_execute_record.end, :etime => @torque_execute_record.etime, :execHost => @torque_execute_record.execHost, :exitStatus => @torque_execute_record.exitStatus, :group => @torque_execute_record.group, :jobName => @torque_execute_record.jobName, :lrmsId => @torque_execute_record.lrmsId, :qtime => @torque_execute_record.qtime, :queue => @torque_execute_record.queue, :recordDate => @torque_execute_record.recordDate, :resourceList_walltime => @torque_execute_record.resourceList_walltime, :resourceList_nodect => @torque_execute_record.resourceList_nodect, :resourceList_nodes => @torque_execute_record.resourceList_nodes, :resourceUsed_cput => @torque_execute_record.resourceUsed_cput, :resourceUsed_mem => @torque_execute_record.resourceUsed_mem, :resourceUsed_vmem => @torque_execute_record.resourceUsed_vmem, :resourceUsed_walltime => @torque_execute_record.resourceUsed_walltime, :session => @torque_execute_record.session, :start => @torque_execute_record.start, :uniqueId => @torque_execute_record.uniqueId, :user => @torque_execute_record.user }
    end

    assert_redirected_to torque_execute_record_path(assigns(:torque_execute_record))
  end

  test "should show torque_execute_record" do
    get :show, :id => @torque_execute_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @torque_execute_record
    assert_response :success
  end

  test "should update torque_execute_record" do
    put :update, :id => @torque_execute_record, :torque_execute_record => { :ctime => @torque_execute_record.ctime, :end => @torque_execute_record.end, :etime => @torque_execute_record.etime, :execHost => @torque_execute_record.execHost, :exitStatus => @torque_execute_record.exitStatus, :group => @torque_execute_record.group, :jobName => @torque_execute_record.jobName, :lrmsId => @torque_execute_record.lrmsId, :qtime => @torque_execute_record.qtime, :queue => @torque_execute_record.queue, :recordDate => @torque_execute_record.recordDate, :resourceList_walltime => @torque_execute_record.resourceList_walltime, :resourceList_nodect => @torque_execute_record.resourceList_nodect, :resourceList_nodes => @torque_execute_record.resourceList_nodes, :resourceUsed_cput => @torque_execute_record.resourceUsed_cput, :resourceUsed_mem => @torque_execute_record.resourceUsed_mem, :resourceUsed_vmem => @torque_execute_record.resourceUsed_vmem, :resourceUsed_walltime => @torque_execute_record.resourceUsed_walltime, :session => @torque_execute_record.session, :start => @torque_execute_record.start, :uniqueId => @torque_execute_record.uniqueId, :user => @torque_execute_record.user }
    assert_redirected_to torque_execute_record_path(assigns(:torque_execute_record))
  end

  test "should destroy torque_execute_record" do
    assert_difference('TorqueExecuteRecord.count', -1) do
      delete :destroy, :id => @torque_execute_record
    end

    assert_redirected_to torque_execute_records_path
  end
end
