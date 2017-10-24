class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == 1 ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = t ".account_not_activated"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "invalid_email_or_password"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end
end
