class ApplicationController < ActionController::Base
  before_filter :userAuthenticate, :publisherAuthenticate
  protect_from_forgery

  protected

  def userAuthenticate
    authenticate_or_request_with_http_basic do |username, password|
      User.authenticate(username,password)
    end
  end
  
  def publisherAuthenticate
    authenticate_or_request_with_http_token do |token, options|
      ip = request.remote_ip
      Publisher.authenticate(ip,token)
    end
  end
end

