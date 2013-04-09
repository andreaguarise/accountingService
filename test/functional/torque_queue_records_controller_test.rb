require 'test_helper'

class TorqueQueueRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @torque_queue_record = torque_queue_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:torque_queue_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create torque_queue_record" do
    assert_difference('TorqueQueueRecord.count') do
      post :create, :torque_queue_record => { :lrmsId => @torque_queue_record.lrmsId, :queue => @torque_queue_record.queue, :recordDate => @torque_queue_record.recordDate, :uniqueId => @torque_queue_record.uniqueId }
    end

    assert_redirected_to torque_queue_record_path(assigns(:torque_queue_record))
  end

  test "should show torque_queue_record" do
    get :show, :id => @torque_queue_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @torque_queue_record
    assert_response :success
  end

  test "should update torque_queue_record" do
    put :update, :id => @torque_queue_record, :torque_queue_record => { :lrmsId => @torque_queue_record.lrmsId, :queue => @torque_queue_record.queue, :recordDate => @torque_queue_record.recordDate, :uniqueId => @torque_queue_record.uniqueId }
    assert_redirected_to torque_queue_record_path(assigns(:torque_queue_record))
  end

  test "should destroy torque_queue_record" do
    assert_difference('TorqueQueueRecord.count', -1) do
      delete :destroy, :id => @torque_queue_record
    end

    assert_redirected_to torque_queue_records_path
  end
end
