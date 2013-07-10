require 'test_helper'

class BatchExecuteRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @batch_execute_record = batch_execute_records(:batch_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:batch_execute_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create batch_execute_record" do
    assert_difference('BatchExecuteRecord.count') do
      post :create, :batch_execute_record => { :ctime => @batch_execute_record.ctime, :end => @batch_execute_record.end, :etime => @batch_execute_record.etime, :execHost => @batch_execute_record.execHost, :exitStatus => @batch_execute_record.exitStatus, :localGroup => @batch_execute_record.localGroup, :jobName => @batch_execute_record.jobName, :lrmsId => @batch_execute_record.lrmsId, :qtime => @batch_execute_record.qtime, :queue => @batch_execute_record.queue, :recordDate => @batch_execute_record.recordDate, :resourceList_walltime => @batch_execute_record.resourceList_walltime, :resourceList_nodect => @batch_execute_record.resourceList_nodect, :resourceList_nodes => @batch_execute_record.resourceList_nodes, :resourceUsed_cput => @batch_execute_record.resourceUsed_cput, :resourceUsed_mem => @batch_execute_record.resourceUsed_mem, :resourceUsed_vmem => @batch_execute_record.resourceUsed_vmem, :resourceUsed_walltime => @batch_execute_record.resourceUsed_walltime, :session => @batch_execute_record.session, :start => @batch_execute_record.start, :uniqueId => @batch_execute_record.uniqueId, :localUser => @batch_execute_record.localUser }
    end
    
    

    assert_redirected_to batch_execute_record_path(assigns(:batch_execute_record))
  end

  test "should show batch_execute_record" do
    get :show, :id => @batch_execute_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @batch_execute_record
    assert_response :success
  end

  test "should update batch_execute_record" do
    put :update, :id => @batch_execute_record, :batch_execute_record => { :ctime => @batch_execute_record.ctime, :end => @batch_execute_record.end, :etime => @batch_execute_record.etime, :execHost => @batch_execute_record.execHost, :exitStatus => @batch_execute_record.exitStatus, :localGroup => @batch_execute_record.localGroup, :jobName => @batch_execute_record.jobName, :lrmsId => @batch_execute_record.lrmsId, :qtime => @batch_execute_record.qtime, :queue => @batch_execute_record.queue, :recordDate => @batch_execute_record.recordDate, :resourceList_walltime => @batch_execute_record.resourceList_walltime, :resourceList_nodect => @batch_execute_record.resourceList_nodect, :resourceList_nodes => @batch_execute_record.resourceList_nodes, :resourceUsed_cput => @batch_execute_record.resourceUsed_cput, :resourceUsed_mem => @batch_execute_record.resourceUsed_mem, :resourceUsed_vmem => @batch_execute_record.resourceUsed_vmem, :resourceUsed_walltime => @batch_execute_record.resourceUsed_walltime, :session => @batch_execute_record.session, :start => @batch_execute_record.start, :uniqueId => @batch_execute_record.uniqueId, :localUser => @batch_execute_record.localUser }
    assert_redirected_to batch_execute_record_path(assigns(:batch_execute_record))
  end

  test "should destroy batch_execute_record" do
    assert_difference('BatchExecuteRecord.count', -1) do
      delete :destroy, :id => @batch_execute_record
    end

    assert_redirected_to batch_execute_records_path
  end
end
