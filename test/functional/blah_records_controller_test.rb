require 'test_helper'

class BlahRecordsControllerTest < ActionController::TestCase
  setup do
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
    request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("1238.1238")
    @blah_record = blah_records(:blah_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blah_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blah_record" do
    assert_difference('BlahRecord.count') do
      post :create, :blah_record => { :ceId => @blah_record.ceId, :clientId => @blah_record.clientId, :jobId => @blah_record.jobId, :localUser => @blah_record.localUser, :lrmsId => @blah_record.lrmsId, :recordDate => @blah_record.recordDate, :timestamp => @blah_record.timestamp, :uniqueId => @blah_record.uniqueId, :userDN => @blah_record.userDN, :userFQAN => @blah_record.userFQAN }
    end

    assert_redirected_to blah_record_path(assigns(:blah_record))
  end

  test "should show blah_record" do
    get :show, :id => @blah_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @blah_record
    assert_response :success
  end

  test "should update blah_record" do
    put :update, :id => @blah_record, :blah_record => { :ceId => @blah_record.ceId, :clientId => @blah_record.clientId, :jobId => @blah_record.jobId, :localUser => @blah_record.localUser, :lrmsId => @blah_record.lrmsId, :recordDate => @blah_record.recordDate, :timestamp => @blah_record.timestamp, :uniqueId => @blah_record.uniqueId, :userDN => @blah_record.userDN, :userFQAN => @blah_record.userFQAN }
    assert_redirected_to blah_record_path(assigns(:blah_record))
  end

  test "should destroy blah_record" do
    assert_difference('BlahRecord.count', -1) do
      delete :destroy, :id => @blah_record
    end

    assert_redirected_to blah_records_path
  end
end
