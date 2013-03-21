require 'test_helper'

class MainControllerTest < ActionController::TestCase
  setup do
    login_as :scrocco if defined? session
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
