require 'test_helper'

class CpuGridIdsControllerTest < ActionController::TestCase
  setup do
    @cpu_grid_id = cpu_grid_ids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cpu_grid_ids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cpu_grid_id" do
    assert_difference('CpuGridId.count') do
      post :create, :cpu_grid_id => { :batch_execute_record_id => @cpu_grid_id.batch_execute_record_id, :blah_record_id => @cpu_grid_id.blah_record_id }
    end

    assert_redirected_to cpu_grid_id_path(assigns(:cpu_grid_id))
  end

  test "should show cpu_grid_id" do
    get :show, :id => @cpu_grid_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cpu_grid_id
    assert_response :success
  end

  test "should update cpu_grid_id" do
    put :update, :id => @cpu_grid_id, :cpu_grid_id => { :batch_execute_record_id => @cpu_grid_id.batch_execute_record_id, :blah_record_id => @cpu_grid_id.blah_record_id }
    assert_redirected_to cpu_grid_id_path(assigns(:cpu_grid_id))
  end

  test "should destroy cpu_grid_id" do
    assert_difference('CpuGridId.count', -1) do
      delete :destroy, :id => @cpu_grid_id
    end

    assert_redirected_to cpu_grid_ids_path
  end
end
