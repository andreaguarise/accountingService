require 'test_helper'

class CloudRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @cloud_record = cloud_records(:one)
    @resource = resources(:one)
    @cloud_record_new = cloud_records(:two)
    @cloud_record_new.VMUUID = "abcdefghilmn"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cloud_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cloud_record" do
    assert_difference('CloudRecord.count') do
      post :create, :cloud_record => { :FQAN => @cloud_record_new.FQAN, :VMUUID => @cloud_record_new.VMUUID, :cloudType => @cloud_record_new.cloudType, :cpuCount => @cloud_record_new.cpuCount, :cpuDuration => @cloud_record_new.cpuDuration, :disk => @cloud_record_new.disk, :diskImage => @cloud_record_new.diskImage, :endTime => @cloud_record_new.endTime, :globaluserName => @cloud_record_new.globaluserName, :localVMID => @cloud_record_new.localVMID, :local_group => @cloud_record_new.local_group, :local_user => @cloud_record_new.local_user, :memory => @cloud_record_new.memory, :networkInbound => @cloud_record_new.networkInbound, :networkOutBound => @cloud_record_new.networkOutBound, :networkType => @cloud_record_new.networkType, :startTime => @cloud_record_new.startTime, :status => @cloud_record_new.status, :storageRecordId => @cloud_record_new.storageRecordId, :suspendDuration => @cloud_record_new.suspendDuration, :wallDuration => @cloud_record_new.wallDuration }, :resource_name => @resource.name    
    end

    assert_redirected_to cloud_record_path(assigns(:cloud_record))
  end

  test "should show cloud_record" do
    get :show, :id => @cloud_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cloud_record
    assert_response :success
  end

  test "should update cloud_record" do
    put :update, :id => @cloud_record, :cloud_record => { :FQAN => @cloud_record.FQAN, :VMUUID => @cloud_record.VMUUID, :cloudType => @cloud_record.cloudType, :cpuCount => @cloud_record.cpuCount, :cpuDuration => @cloud_record.cpuDuration, :disk => @cloud_record.disk, :diskImage => @cloud_record.diskImage, :endTime => @cloud_record.endTime, :globaluserName => @cloud_record.globaluserName, :localVMID => @cloud_record.localVMID, :local_group => @cloud_record.local_group, :local_user => @cloud_record.local_user, :memory => @cloud_record.memory, :networkInbound => @cloud_record.networkInbound, :networkOutBound => @cloud_record.networkOutBound, :networkType => @cloud_record.networkType, :resource_id => @cloud_record.resource_id, :startTime => @cloud_record.startTime, :status => @cloud_record.status, :storageRecordId => @cloud_record.storageRecordId, :suspendDuration => @cloud_record.suspendDuration, :wallDuration => @cloud_record.wallDuration }
    assert_redirected_to cloud_record_path(assigns(:cloud_record))
  end

  test "should destroy cloud_record" do
    assert_difference('CloudRecord.count', -1) do
      delete :destroy, :id => @cloud_record
    end

    assert_redirected_to cloud_records_path
  end
end
