require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  describe "POST #create" do
    context "Auth Success" do
      it "creates a user" do
        expect do
          post :create, provider: :twitter
        end.to change(User, :count).by(1)
      end

      it "creates a session" do
        post :create, provider: :twitter
        expect(session[:user_id]).not_to be_nil
      end

      it "redirects the user to the root url" do
        post :create, provider: :twitter
        expect(response).to redirect_to root_url
      end
    end

    context "Auth Failure" do
      it "gives error message" do
        request.env["omniauth.auth"] = :invalid_credentials
        post :create, provider: :twitter
        should set_flash[:danger].to(
          "An error occured while trying to sing you in."
        )
      end
    end
  end

  describe "DELETE #destroy" do
    before { post :create, provider: :twitter }

    it "clears the session" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects the user to the home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end
end
