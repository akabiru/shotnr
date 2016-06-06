class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  def login(user_id)
    session[:user_id] = user_id
  end

  def logout
    session.clear
    @current_user = nil
  end

  def login_required
    redirect_to root_path unless logged_in?
  end
end
