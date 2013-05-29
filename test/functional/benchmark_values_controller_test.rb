require 'test_helper'

class BenchmarkValuesControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @benchmark_value = benchmark_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:benchmark_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create benchmark_value" do
    assert_difference('BenchmarkValue.count') do
      post :create, :benchmark_value => { :benchmark_type_id => @benchmark_value.benchmark_type_id, :date => @benchmark_value.date, :publisher_id => @benchmark_value.publisher_id, :value => @benchmark_value.value }
    end

    assert_redirected_to benchmark_value_path(assigns(:benchmark_value))
  end

  test "should show benchmark_value" do
    get :show, :id => @benchmark_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @benchmark_value
    assert_response :success
  end

  test "should update benchmark_value" do
    put :update, :id => @benchmark_value, :benchmark_value => { :benchmark_type_id => @benchmark_value.benchmark_type_id, :date => @benchmark_value.date, :publisher_id => @benchmark_value.publisher_id, :value => @benchmark_value.value }
    assert_redirected_to benchmark_value_path(assigns(:benchmark_value))
  end

  test "should destroy benchmark_value" do
    assert_difference('BenchmarkValue.count', -1) do
      delete :destroy, :id => @benchmark_value
    end

    assert_redirected_to benchmark_values_path
  end
end
