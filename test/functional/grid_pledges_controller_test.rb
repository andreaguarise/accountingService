require 'test_helper'

class GridPledgesControllerTest < ActionController::TestCase
  setup do
    @grid_pledge = grid_pledges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grid_pledges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grid_pledge" do
    assert_difference('GridPledge.count') do
      post :create, :grid_pledge => { :benchmark_type_id => @grid_pledge.benchmark_type_id, :logicalCPU => @grid_pledge.logicalCPU, :physicalCPU => @grid_pledge.physicalCPU, :site_id => @grid_pledge.site_id, :validFrom => @grid_pledge.validFrom, :validTo => @grid_pledge.validTo, :value => @grid_pledge.value }
    end

    assert_redirected_to grid_pledge_path(assigns(:grid_pledge))
  end

  test "should show grid_pledge" do
    get :show, :id => @grid_pledge
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @grid_pledge
    assert_response :success
  end

  test "should update grid_pledge" do
    put :update, :id => @grid_pledge, :grid_pledge => { :benchmark_type_id => @grid_pledge.benchmark_type_id, :logicalCPU => @grid_pledge.logicalCPU, :physicalCPU => @grid_pledge.physicalCPU, :site_id => @grid_pledge.site_id, :validFrom => @grid_pledge.validFrom, :validTo => @grid_pledge.validTo, :value => @grid_pledge.value }
    assert_redirected_to grid_pledge_path(assigns(:grid_pledge))
  end

  test "should destroy grid_pledge" do
    assert_difference('GridPledge.count', -1) do
      delete :destroy, :id => @grid_pledge
    end

    assert_redirected_to grid_pledges_path
  end
end
