require 'test_helper'

class EmiStorageRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @emi_storage_record = emi_storage_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emi_storage_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create emi_storage_record" do
    assert_difference('EmiStorageRecord.count') do
      post :create, :emi_storage_record => { :attributeType => @emi_storage_record.attributeType, :directoryPath => @emi_storage_record.directoryPath, :endTime => @emi_storage_record.endTime, :fileCount => @emi_storage_record.fileCount, :group => @emi_storage_record.group, :groupAttribute => @emi_storage_record.groupAttribute, :localGroup => @emi_storage_record.localGroup, :localUser => @emi_storage_record.localUser, :logicalCapacityUsed => @emi_storage_record.logicalCapacityUsed, :recordIdentity => @emi_storage_record.recordIdentity, :resourceCapacityAllocated => @emi_storage_record.resourceCapacityAllocated, :resourceCapacityUsed => @emi_storage_record.resourceCapacityUsed, :site => @emi_storage_record.site, :startTime => @emi_storage_record.startTime, :storageClass => @emi_storage_record.storageClass, :storageMedia => @emi_storage_record.storageMedia, :storageShare => @emi_storage_record.storageShare, :storageSystem => @emi_storage_record.storageSystem, :userIdentity => @emi_storage_record.userIdentity }
    end

    assert_redirected_to emi_storage_record_path(assigns(:emi_storage_record))
  end

  test "should show emi_storage_record" do
    get :show, :id => @emi_storage_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @emi_storage_record
    assert_response :success
  end

  test "should update emi_storage_record" do
    put :update, :id => @emi_storage_record, :emi_storage_record => { :attributeType => @emi_storage_record.attributeType, :directoryPath => @emi_storage_record.directoryPath, :endTime => @emi_storage_record.endTime, :fileCount => @emi_storage_record.fileCount, :group => @emi_storage_record.group, :groupAttribute => @emi_storage_record.groupAttribute, :localGroup => @emi_storage_record.localGroup, :localUser => @emi_storage_record.localUser, :logicalCapacityUsed => @emi_storage_record.logicalCapacityUsed, :recordIdentity => @emi_storage_record.recordIdentity, :resourceCapacityAllocated => @emi_storage_record.resourceCapacityAllocated, :resourceCapacityUsed => @emi_storage_record.resourceCapacityUsed, :site => @emi_storage_record.site, :startTime => @emi_storage_record.startTime, :storageClass => @emi_storage_record.storageClass, :storageMedia => @emi_storage_record.storageMedia, :storageShare => @emi_storage_record.storageShare, :storageSystem => @emi_storage_record.storageSystem, :userIdentity => @emi_storage_record.userIdentity }
    assert_redirected_to emi_storage_record_path(assigns(:emi_storage_record))
  end

  test "should destroy emi_storage_record" do
    assert_difference('EmiStorageRecord.count', -1) do
      delete :destroy, :id => @emi_storage_record
    end

    assert_redirected_to emi_storage_records_path
  end
end
