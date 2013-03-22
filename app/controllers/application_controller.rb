class ApplicationController < ActionController::Base
  before_filter :userAuthenticate, :publisherAuthenticate
  protect_from_forgery

  protected
  def userAuthenticate
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, :notice => "Please log in"
    end
  end

  def publisherAuthenticate
    unless session[:user_id]

      authenticate_or_request_with_http_token do |token, options|
        ip = request.remote_ip
        Publisher.authenticate(ip,token)
      end
    end
  end
end

