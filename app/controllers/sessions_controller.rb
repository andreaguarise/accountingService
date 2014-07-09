include AuthTkt

class SessionsController < ApplicationController
  skip_before_filter :publisherAuthenticate, :userAuthenticate
  def new
  end

  def create
    if user = User.authenticate(params[:name], params[:password])
      session[:user_id] = user.id
      session[:role] = user.role.name
      cookie = set_auth_tkt_cookie({:user => user.name,:token_list => "", :user_data => "", :encode => true, :ignore_ip => true })
      logger.info "set cookie: #{cookie}"
      redirect_to main_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:role] = nil
    destroy_auth_tkt_cookie
    redirect_to main_url, :notice => "Logged out"
  end
end
