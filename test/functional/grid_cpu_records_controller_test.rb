require 'test_helper'

class GridCpuRecordsControllerTest < ActionController::TestCase
  setup do
    @grid_cpu_record = grid_cpu_records(:one)
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

  test "should create grid_cpu_record" do
    assert_difference('GridCpuRecord.count') do
      post :create, :grid_cpu_record => { :blah_record_id => @grid_cpu_record.blah_record_id, :recordlike_id => @grid_cpu_record.recordlike_id, :recordlike_type => @grid_cpu_record.recordlike_type }
    end

    assert_redirected_to grid_cpu_record_path(assigns(:grid_cpu_record))
  end

  test "should show grid_cpu_record" do
    get :show, :id => @grid_cpu_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @grid_cpu_record
    assert_response :success
  end

  test "should update grid_cpu_record" do
    put :update, :id => @grid_cpu_record, :grid_cpu_record => { :blah_record_id => @grid_cpu_record.blah_record_id, :recordlike_id => @grid_cpu_record.recordlike_id, :recordlike_type => @grid_cpu_record.recordlike_type }
    assert_redirected_to grid_cpu_record_path(assigns(:grid_cpu_record))
  end

  test "should destroy grid_cpu_record" do
    assert_difference('GridCpuRecord.count', -1) do
      delete :destroy, :id => @grid_cpu_record
    end

    assert_redirected_to grid_cpu_records_path
  end
end
