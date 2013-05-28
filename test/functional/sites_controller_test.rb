require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    login_as :scrocco if defined? session
    @site = sites(:one)
    @site.name = "newUniqueName"
    @site_two = sites(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, :site => { :description => @site.description, :name => @site.name }
    end

    assert_redirected_to site_path(assigns(:site))
  end
  
  test "should fail create site with duplicate name" do
    assert_no_difference('Site.count') do
      post :create, :site => { :description => @site_two.description, :name => @site_two.name }
    end
  end

  test "should show site" do
    get :show, :id => @site
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site
    assert_response :success
  end

  test "should update site" do
    put :update, :id => @site, :site => { :description => @site.description, :name => @site.name }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, :id => @site
    end

    assert_redirected_to sites_path
  end
end
