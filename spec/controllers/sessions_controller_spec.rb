require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  describe "#create" do
    it "should create a user successfully" do
      expect do
        post :create, provider: :twitter
      end.to change(User, :count).by(1)
    end

    it "should successfully create a session" do
      expect(session[:user_id]).to be_nil
      post :create, provider: :twitter
      expect(session[:user_id]).not_to be_nil
    end

    it "should redirect the user to the root url" do
      post :create, provider: :twitter
      expect(response).to redirect_to root_url
    end

    context "Auth Failure" do
      it "gives error message if auth fails" do
        request.env["omniauth.auth"] = :invalid_credentials
        post :create, provider: :twitter
        should set_flash[:danger].to(
          "An error occured while trying to sing you in."
        )
      end
    end
  end

  describe "#destroy" do
    before do
      post :create, provider: :twitter
    end

    it "should clear the session" do
      expect(session[:user_id]).not_to be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "should redirect the user to the home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end
end
