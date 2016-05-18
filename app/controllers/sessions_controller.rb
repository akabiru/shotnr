class SessionsController < ApplicationController
  def create
    begin
      user = User.from_omni_auth(request.env["omniauth.auth"])
      log_in(user.id)
    rescue
      flash[:danger] = "An error occured while trying to sing you in."
    end
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to root_url
  end
end
