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
        session[:token] = token
        Publisher.authenticate(ip,token)
      end
    end
  end
  
  def skipMassAssign (base)
    if params[base][:created_at]
      params[base].delete(:created_at)
    end
    if params[base][:updated_at]
      params[base].delete(:updated_at)
    end
    if params[base][:id]
      params[base].delete(:id)
    end
  end
  
  def tableSort! ( table, params, default_key )
    params[:sort] = default_key if not params[:sort]
    table = table.sort_by{|e| e[params[:sort]]}
    table.reverse! if params[:desc]
    table
  end
  
end

