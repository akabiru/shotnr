class SessionsController < ApplicationController
  before_action :login_required, only: [:destroy]
  def create
    begin
      user = User.from_omni_auth(request.env["omniauth.auth"])
      log_in(user.id)
    rescue
      session_create_failure("An error occured while trying to sing you in.")
    end
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to root_url
  end

  private

  def session_create_failure(msg)
    flash[:danger] = "#{msg}"
  end
end
