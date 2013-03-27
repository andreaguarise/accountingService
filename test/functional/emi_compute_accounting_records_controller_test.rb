require 'test_helper'

class EmiComputeAccountingRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @emi_compute_accounting_record = emi_compute_accounting_records(:one)
    @emi_compute_accounting_record_new = emi_compute_accounting_records(:two)
    @emi_compute_accounting_record_new.recordId = "abcdefghilmn"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emi_compute_accounting_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create emi_compute_accounting_record" do
    assert_difference('EmiComputeAccountingRecord.count') do
      post :create, :emi_compute_accounting_record => { :ceCertificateSubject => @emi_compute_accounting_record_new.ceCertificateSubject, :ceHost => @emi_compute_accounting_record_new.ceHost, :charge => @emi_compute_accounting_record_new.charge, :cpuDuration => @emi_compute_accounting_record_new.cpuDuration, :createTime => @emi_compute_accounting_record_new.createTime, :dgasAccountingProcedure => @emi_compute_accounting_record_new.dgasAccountingProcedure, :endTime => @emi_compute_accounting_record_new.endTime, :execHost => @emi_compute_accounting_record_new.execHost, :globalJobId => @emi_compute_accounting_record_new.globalJobId, :globalUserName => @emi_compute_accounting_record_new.globalUserName, :group => @emi_compute_accounting_record_new.group, :jobName => @emi_compute_accounting_record_new.jobName, :localJobId => @emi_compute_accounting_record_new.localJobId, :localUserId => @emi_compute_accounting_record_new.localUserId, :machineName => @emi_compute_accounting_record_new.machineName, :physicalMemory => @emi_compute_accounting_record_new.physicalMemory, :projectName => @emi_compute_accounting_record_new.projectName, :queue => @emi_compute_accounting_record_new.queue, :recordId => @emi_compute_accounting_record_new.recordId, :serviceLevelFloatBench => @emi_compute_accounting_record_new.serviceLevelFloatBench, :serviceLevelFloatBenchType => @emi_compute_accounting_record_new.serviceLevelFloatBenchType, :serviceLevelIntBench => @emi_compute_accounting_record_new.serviceLevelIntBench, :serviceLevelIntBenchType => @emi_compute_accounting_record_new.serviceLevelIntBenchType, :startTime => @emi_compute_accounting_record_new.startTime, :status => @emi_compute_accounting_record_new.status, :timeInstantCtime => @emi_compute_accounting_record_new.timeInstantCtime, :timeInstantETime => @emi_compute_accounting_record_new.timeInstantETime, :timeInstantQTime => @emi_compute_accounting_record_new.timeInstantQTime, :virtualMemory => @emi_compute_accounting_record_new.virtualMemory, :voOrigin => @emi_compute_accounting_record_new.voOrigin, :vomsFQAN => @emi_compute_accounting_record_new.vomsFQAN, :wallDuration => @emi_compute_accounting_record_new.wallDuration }
    end

    assert_redirected_to emi_compute_accounting_record_path(assigns(:emi_compute_accounting_record))
  end

  test "should show emi_compute_accounting_record" do
    get :show, :id => @emi_compute_accounting_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @emi_compute_accounting_record
    assert_response :success
  end

  test "should update emi_compute_accounting_record" do
    put :update, :id => @emi_compute_accounting_record, :emi_compute_accounting_record => { :ceCertificateSubject => @emi_compute_accounting_record.ceCertificateSubject, :ceHost => @emi_compute_accounting_record.ceHost, :charge => @emi_compute_accounting_record.charge, :cpuDuration => @emi_compute_accounting_record.cpuDuration, :createTime => @emi_compute_accounting_record.createTime, :dgasAccountingProcedure => @emi_compute_accounting_record.dgasAccountingProcedure, :endTime => @emi_compute_accounting_record.endTime,  :execHost => @emi_compute_accounting_record.execHost, :globalJobId => @emi_compute_accounting_record.globalJobId, :globalUserName => @emi_compute_accounting_record.globalUserName, :group => @emi_compute_accounting_record.group, :jobName => @emi_compute_accounting_record.jobName, :localJobId => @emi_compute_accounting_record.localJobId, :localUserId => @emi_compute_accounting_record.localUserId, :machineName => @emi_compute_accounting_record.machineName, :physicalMemory => @emi_compute_accounting_record.physicalMemory, :projectName => @emi_compute_accounting_record.projectName, :queue => @emi_compute_accounting_record.queue, :recordId => @emi_compute_accounting_record.recordId, :serviceLevelFloatBench => @emi_compute_accounting_record.serviceLevelFloatBench, :serviceLevelFloatBenchType => @emi_compute_accounting_record.serviceLevelFloatBenchType, :serviceLevelIntBench => @emi_compute_accounting_record.serviceLevelIntBench, :serviceLevelIntBenchType => @emi_compute_accounting_record.serviceLevelIntBenchType, :startTime => @emi_compute_accounting_record.startTime, :status => @emi_compute_accounting_record.status, :timeInstantCtime => @emi_compute_accounting_record.timeInstantCtime, :timeInstantETime => @emi_compute_accounting_record.timeInstantETime, :timeInstantQTime => @emi_compute_accounting_record.timeInstantQTime, :virtualMemory => @emi_compute_accounting_record.virtualMemory, :voOrigin => @emi_compute_accounting_record.voOrigin, :vomsFQAN => @emi_compute_accounting_record.vomsFQAN, :wallDuration => @emi_compute_accounting_record.wallDuration }
    assert_redirected_to emi_compute_accounting_record_path(assigns(:emi_compute_accounting_record))
  end

  test "should destroy emi_compute_accounting_record" do
    assert_difference('EmiComputeAccountingRecord.count', -1) do
      delete :destroy, :id => @emi_compute_accounting_record
    end

    assert_redirected_to emi_compute_accounting_records_path
  end
end