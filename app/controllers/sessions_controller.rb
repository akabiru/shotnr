class SessionsController < ApplicationController
  before_action :login_required, only: [:destroy]
  def create
    begin
      user = User.from_omni_auth(request.env["omniauth.auth"])
      login(user.id)
    rescue
      Message.new(
        flash,
        "danger",
        "An error occured while trying to sign you in."
      ).set_flash
    end
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to root_url
  end
end
