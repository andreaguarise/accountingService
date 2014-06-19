require 'test_helper'

class CpuGridSummariesControllerTest < ActionController::TestCase
  setup do
    @cpu_grid_summary = cpu_grid_summaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cpu_grid_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cpu_grid_summary" do
    assert_difference('CpuGridSummary.count') do
      post :create, :cpu_grid_summary => { :FQAN => @cpu_grid_summary.FQAN, :benchmark_type_id => @cpu_grid_summary.benchmark_type_id, :benchmark_value => @cpu_grid_summary.benchmark_value, :cput => @cpu_grid_summary.cput, :date => @cpu_grid_summary.date, :publisher_id => @cpu_grid_summary.publisher_id, :records => @cpu_grid_summary.records, :userDN => @cpu_grid_summary.userDN, :vo => @cpu_grid_summary.vo, :wallt => @cpu_grid_summary.wallt }
    end

    assert_redirected_to cpu_grid_summary_path(assigns(:cpu_grid_summary))
  end

  test "should show cpu_grid_summary" do
    get :show, :id => @cpu_grid_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cpu_grid_summary
    assert_response :success
  end

  test "should update cpu_grid_summary" do
    put :update, :id => @cpu_grid_summary, :cpu_grid_summary => { :FQAN => @cpu_grid_summary.FQAN, :benchmark_type_id => @cpu_grid_summary.benchmark_type_id, :benchmark_value => @cpu_grid_summary.benchmark_value, :cput => @cpu_grid_summary.cput, :date => @cpu_grid_summary.date, :publisher_id => @cpu_grid_summary.publisher_id, :records => @cpu_grid_summary.records, :userDN => @cpu_grid_summary.userDN, :vo => @cpu_grid_summary.vo, :wallt => @cpu_grid_summary.wallt }
    assert_redirected_to cpu_grid_summary_path(assigns(:cpu_grid_summary))
  end

  test "should destroy cpu_grid_summary" do
    assert_difference('CpuGridSummary.count', -1) do
      delete :destroy, :id => @cpu_grid_summary
    end

    assert_redirected_to cpu_grid_summaries_path
  end
end
