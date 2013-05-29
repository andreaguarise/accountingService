require 'test_helper'

class BenchmarkTypesControllerTest < ActionController::TestCase
  setup do
    login_as :scrocco if defined? session
    @benchmark_type = benchmark_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:benchmark_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create benchmark_type" do
    assert_difference('BenchmarkType.count') do
      post :create, :benchmark_type => { :description => @benchmark_type.description, :name => @benchmark_type.name }
    end

    assert_redirected_to benchmark_type_path(assigns(:benchmark_type))
  end

  test "should show benchmark_type" do
    get :show, :id => @benchmark_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @benchmark_type
    assert_response :success
  end

  test "should update benchmark_type" do
    put :update, :id => @benchmark_type, :benchmark_type => { :description => @benchmark_type.description, :name => @benchmark_type.name }
    assert_redirected_to benchmark_type_path(assigns(:benchmark_type))
  end

  test "should destroy benchmark_type" do
    assert_difference('BenchmarkType.count', -1) do
      delete :destroy, :id => @benchmark_type
    end

    assert_redirected_to benchmark_types_path
  end
end
