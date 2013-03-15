class ApplicationController < ActionController::Base
  before_filter :userAuthenticate
  protect_from_forgery

  protected

  def userAuthenticate
    authenticate_or_request_with_http_basic do |username, password|
      User.authenticate(username,password)
    end
  end
end

