class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email]

    if user&.authenticate(params[:session][:password])
      check_user_is_activated user
    else
      flash.now[:danger] = t ".invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_user_is_activated user
    if user.activated?
      log_in user
      params[:session][:remember_me] == 1 ? remember(user) : forget(user)
      redirect_to(session[:forwarding_url] || root_url)
      session.delete :forwarding_url
    else
      flash[:warning] = t ".check_email_for_account_activation"
      redirect_to root_url
    end
  end
end
