require 'test_helper'

class GridCpuRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @grid_cpu_record = grid_cpu_records(:one)
    @grid_cpu_record.blah_record = blah_records(:blah_three)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grid_cpu_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

#  test "should create grid_cpu_record" do
#    assert_difference('GridCpuRecord.count') do
#      post :create, :grid_cpu_record => { :blah_record_id => @grid_cpu_record.blah_record_id, :batch_execute_record_id => @grid_cpu_record.batch_execute_record_id }
#    end

#    assert_redirected_to grid_cpu_record_path(assigns(:grid_cpu_record))
#  end

  test "should show grid_cpu_record" do
    get :show, :id => @grid_cpu_record
    assert_response :success
  end

#  test "should get edit" do
#    get :edit, :id => @grid_cpu_record
#    assert_response :success
#  end

#  test "should update grid_cpu_record" do
#    put :update, :id => @grid_cpu_record, :grid_cpu_record => { :blah_record_id => @grid_cpu_record.blah_record_id, :batch_execute_record_id => @grid_cpu_record.batch_execute_record_id }
#   assert_redirected_to grid_cpu_record_path(assigns(:grid_cpu_record))
#  end

#  test "should destroy grid_cpu_record" do
#    assert_difference('GridCpuRecord.count', -1) do
#      delete :destroy, :id => @grid_cpu_record
#    end

#    assert_redirected_to grid_cpu_records_path
#  end
end
