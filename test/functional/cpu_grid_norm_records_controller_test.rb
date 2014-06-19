require 'test_helper'

class CpuGridNormRecordsControllerTest < ActionController::TestCase
  setup do
    @cpu_grid_norm_record = cpu_grid_norm_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cpu_grid_norm_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cpu_grid_norm_record" do
    assert_difference('CpuGridNormRecord.count') do
      post :create, :cpu_grid_norm_record => { :FQAN => @cpu_grid_norm_record.FQAN, :benchmark_value_id => @cpu_grid_norm_record.benchmark_value_id, :cput => @cpu_grid_norm_record.cput, :execHost => @cpu_grid_norm_record.execHost, :localUser => @cpu_grid_norm_record.localUser, :lrmsId => @cpu_grid_norm_record.lrmsId, :nodect => @cpu_grid_norm_record.nodect, :nodes => @cpu_grid_norm_record.nodes, :pmem => @cpu_grid_norm_record.pmem, :publisher_id => @cpu_grid_norm_record.publisher_id, :recordDate => @cpu_grid_norm_record.recordDate, :userDN => @cpu_grid_norm_record.userDN, :vmem => @cpu_grid_norm_record.vmem, :wallt => @cpu_grid_norm_record.wallt }
    end

    assert_redirected_to cpu_grid_norm_record_path(assigns(:cpu_grid_norm_record))
  end

  test "should show cpu_grid_norm_record" do
    get :show, :id => @cpu_grid_norm_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cpu_grid_norm_record
    assert_response :success
  end

  test "should update cpu_grid_norm_record" do
    put :update, :id => @cpu_grid_norm_record, :cpu_grid_norm_record => { :FQAN => @cpu_grid_norm_record.FQAN, :benchmark_value_id => @cpu_grid_norm_record.benchmark_value_id, :cput => @cpu_grid_norm_record.cput, :execHost => @cpu_grid_norm_record.execHost, :localUser => @cpu_grid_norm_record.localUser, :lrmsId => @cpu_grid_norm_record.lrmsId, :nodect => @cpu_grid_norm_record.nodect, :nodes => @cpu_grid_norm_record.nodes, :pmem => @cpu_grid_norm_record.pmem, :publisher_id => @cpu_grid_norm_record.publisher_id, :recordDate => @cpu_grid_norm_record.recordDate, :userDN => @cpu_grid_norm_record.userDN, :vmem => @cpu_grid_norm_record.vmem, :wallt => @cpu_grid_norm_record.wallt }
    assert_redirected_to cpu_grid_norm_record_path(assigns(:cpu_grid_norm_record))
  end

  test "should destroy cpu_grid_norm_record" do
    assert_difference('CpuGridNormRecord.count', -1) do
      delete :destroy, :id => @cpu_grid_norm_record
    end

    assert_redirected_to cpu_grid_norm_records_path
  end
end
