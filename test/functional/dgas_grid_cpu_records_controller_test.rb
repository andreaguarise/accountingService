require 'test_helper'

class DgasGridCpuRecordsControllerTest < ActionController::TestCase
  setup do
    @dgas_grid_cpu_record = dgas_grid_cpu_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dgas_grid_cpu_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dgas_grid_cpu_record" do
    assert_difference('DgasGridCpuRecord.count') do
      post :create, :dgas_grid_cpu_record => { :FQAN => @dgas_grid_cpu_record.FQAN, :accountingProcedure => @dgas_grid_cpu_record.accountingProcedure, :cpuTime => @dgas_grid_cpu_record.cpuTime, :dgJobId => @dgas_grid_cpu_record.dgJobId, :endDate => @dgas_grid_cpu_record.endDate, :executingNodes => @dgas_grid_cpu_record.executingNodes, :fBench => @dgas_grid_cpu_record.fBench, :fBenchType => @dgas_grid_cpu_record.fBenchType, :globaluserName => @dgas_grid_cpu_record.globaluserName, :iBench => @dgas_grid_cpu_record.iBench, :iBenchType => @dgas_grid_cpu_record.iBenchType, :local_group => @dgas_grid_cpu_record.local_group, :local_user => @dgas_grid_cpu_record.local_user, :lrmsID => @dgas_grid_cpu_record.lrmsID, :numNodes => @dgas_grid_cpu_record.numNodes, :pmem => @dgas_grid_cpu_record.pmem, :resource_id => @dgas_grid_cpu_record.resource_id, :startDate => @dgas_grid_cpu_record.startDate, :uniqueChecksum => @dgas_grid_cpu_record.uniqueChecksum, :urSource => @dgas_grid_cpu_record.urSource, :userVO => @dgas_grid_cpu_record.userVO, :vmem => @dgas_grid_cpu_record.vmem, :voOrigin => @dgas_grid_cpu_record.voOrigin, :wallTime => @dgas_grid_cpu_record.wallTime }
    end

    assert_redirected_to dgas_grid_cpu_record_path(assigns(:dgas_grid_cpu_record))
  end

  test "should show dgas_grid_cpu_record" do
    get :show, :id => @dgas_grid_cpu_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @dgas_grid_cpu_record
    assert_response :success
  end

  test "should update dgas_grid_cpu_record" do
    put :update, :id => @dgas_grid_cpu_record, :dgas_grid_cpu_record => { :FQAN => @dgas_grid_cpu_record.FQAN, :accountingProcedure => @dgas_grid_cpu_record.accountingProcedure, :cpuTime => @dgas_grid_cpu_record.cpuTime, :dgJobId => @dgas_grid_cpu_record.dgJobId, :endDate => @dgas_grid_cpu_record.endDate, :executingNodes => @dgas_grid_cpu_record.executingNodes, :fBench => @dgas_grid_cpu_record.fBench, :fBenchType => @dgas_grid_cpu_record.fBenchType, :globaluserName => @dgas_grid_cpu_record.globaluserName, :iBench => @dgas_grid_cpu_record.iBench, :iBenchType => @dgas_grid_cpu_record.iBenchType, :local_group => @dgas_grid_cpu_record.local_group, :local_user => @dgas_grid_cpu_record.local_user, :lrmsID => @dgas_grid_cpu_record.lrmsID, :numNodes => @dgas_grid_cpu_record.numNodes, :pmem => @dgas_grid_cpu_record.pmem, :resource_id => @dgas_grid_cpu_record.resource_id, :startDate => @dgas_grid_cpu_record.startDate, :uniqueChecksum => @dgas_grid_cpu_record.uniqueChecksum, :urSource => @dgas_grid_cpu_record.urSource, :userVO => @dgas_grid_cpu_record.userVO, :vmem => @dgas_grid_cpu_record.vmem, :voOrigin => @dgas_grid_cpu_record.voOrigin, :wallTime => @dgas_grid_cpu_record.wallTime }
    assert_redirected_to dgas_grid_cpu_record_path(assigns(:dgas_grid_cpu_record))
  end

  test "should destroy dgas_grid_cpu_record" do
    assert_difference('DgasGridCpuRecord.count', -1) do
      delete :destroy, :id => @dgas_grid_cpu_record
    end

    assert_redirected_to dgas_grid_cpu_records_path
  end
end
