module SessionsHelper
  def log_in(user)
    session[:user_id] = user
  end

  def logout
    session.clear
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end
end
