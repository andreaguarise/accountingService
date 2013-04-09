require 'test_helper'

class TorqueDispatchRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @torque_dispatch_record = torque_dispatch_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:torque_dispatch_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create torque_dispatch_record" do
    assert_difference('TorqueDispatchRecord.count') do
      post :create, :torque_dispatch_record => { :lrmsId => @torque_dispatch_record.lrmsId, :recordDate => @torque_dispatch_record.recordDate, :requestor => @torque_dispatch_record.requestor, :uniqueId => @torque_dispatch_record.uniqueId }
    end

    assert_redirected_to torque_dispatch_record_path(assigns(:torque_dispatch_record))
  end

  test "should show torque_dispatch_record" do
    get :show, :id => @torque_dispatch_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @torque_dispatch_record
    assert_response :success
  end

  test "should update torque_dispatch_record" do
    put :update, :id => @torque_dispatch_record, :torque_dispatch_record => { :lrmsId => @torque_dispatch_record.lrmsId, :recordDate => @torque_dispatch_record.recordDate, :requestor => @torque_dispatch_record.requestor, :uniqueId => @torque_dispatch_record.uniqueId }
    assert_redirected_to torque_dispatch_record_path(assigns(:torque_dispatch_record))
  end

  test "should destroy torque_dispatch_record" do
    assert_difference('TorqueDispatchRecord.count', -1) do
      delete :destroy, :id => @torque_dispatch_record
    end

    assert_redirected_to torque_dispatch_records_path
  end
end
