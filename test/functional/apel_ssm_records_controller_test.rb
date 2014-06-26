require 'test_helper'

class ApelSsmRecordsControllerTest < ActionController::TestCase
  setup do
    @apel_ssm_record = apel_ssm_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apel_ssm_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apel_ssm_record" do
    assert_difference('ApelSsmRecord.count') do
      post :create, :apel_ssm_record => { :cpuDuration => @apel_ssm_record.cpuDuration, :endTime => @apel_ssm_record.endTime, :fqan => @apel_ssm_record.fqan, :globalUserName => @apel_ssm_record.globalUserName, :infrastructureDescription => @apel_ssm_record.infrastructureDescription, :infrastructureType => @apel_ssm_record.infrastructureType, :localJobId => @apel_ssm_record.localJobId, :localUserId => @apel_ssm_record.localUserId, :machineName => @apel_ssm_record.machineName, :memoryReal => @apel_ssm_record.memoryReal, :memoryVirtual => @apel_ssm_record.memoryVirtual, :nodeCount => @apel_ssm_record.nodeCount, :processors => @apel_ssm_record.processors, :publisher_id => @apel_ssm_record.publisher_id, :queue => @apel_ssm_record.queue, :recordDate => @apel_ssm_record.recordDate, :startTime => @apel_ssm_record.startTime, :submitHost => @apel_ssm_record.submitHost, :vo => @apel_ssm_record.vo, :voGroup => @apel_ssm_record.voGroup, :voRole => @apel_ssm_record.voRole, :wallDuration => @apel_ssm_record.wallDuration }
    end

    assert_redirected_to apel_ssm_record_path(assigns(:apel_ssm_record))
  end

  test "should show apel_ssm_record" do
    get :show, :id => @apel_ssm_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @apel_ssm_record
    assert_response :success
  end

  test "should update apel_ssm_record" do
    put :update, :id => @apel_ssm_record, :apel_ssm_record => { :cpuDuration => @apel_ssm_record.cpuDuration, :endTime => @apel_ssm_record.endTime, :fqan => @apel_ssm_record.fqan, :globalUserName => @apel_ssm_record.globalUserName, :infrastructureDescription => @apel_ssm_record.infrastructureDescription, :infrastructureType => @apel_ssm_record.infrastructureType, :localJobId => @apel_ssm_record.localJobId, :localUserId => @apel_ssm_record.localUserId, :machineName => @apel_ssm_record.machineName, :memoryReal => @apel_ssm_record.memoryReal, :memoryVirtual => @apel_ssm_record.memoryVirtual, :nodeCount => @apel_ssm_record.nodeCount, :processors => @apel_ssm_record.processors, :publisher_id => @apel_ssm_record.publisher_id, :queue => @apel_ssm_record.queue, :recordDate => @apel_ssm_record.recordDate, :startTime => @apel_ssm_record.startTime, :submitHost => @apel_ssm_record.submitHost, :vo => @apel_ssm_record.vo, :voGroup => @apel_ssm_record.voGroup, :voRole => @apel_ssm_record.voRole, :wallDuration => @apel_ssm_record.wallDuration }
    assert_redirected_to apel_ssm_record_path(assigns(:apel_ssm_record))
  end

  test "should destroy apel_ssm_record" do
    assert_difference('ApelSsmRecord.count', -1) do
      delete :destroy, :id => @apel_ssm_record
    end

    assert_redirected_to apel_ssm_records_path
  end
end
