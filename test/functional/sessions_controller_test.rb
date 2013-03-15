require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    scrocco = users(:scrocco)
    post :create, :name => scrocco.name, :password => '1,2,3,4,5' 
    assert_redirected_to users_url
    assert_equal scrocco.id, session[:user_id]
  end

 test "should fail login" do
    scrocco = users(:scrocco)
    post :create, :name => scrocco.name, :password => 'wrong'
    assert_redirected_to login_url
  end
  
 test "should logout" do
    delete :destroy
    assert_redirected_to users_url
  end

end
