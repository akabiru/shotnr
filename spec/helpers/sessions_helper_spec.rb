require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  describe "#login_in" do
    it "sets the session user_id to current user id" do
      user = create(:user)
      log_in(user.id)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "#logout" do
    it "clears the session user_id and current_user" do
      user = create(:user)
      log_in(user.id)
      logout
      expect(session[:user_id]).to be nil
      expect(assigns(:current_user)).to be nil
    end
  end

  describe "#current_user" do
    it "returns a user from the session and assigns to @current_user" do
      user = create(:user)
      log_in(user.id)
      expect(current_user.id).to eq(user.id)
    end
  end

  describe "#logged_in?" do
    it "returns true if user is logged in" do
      user = create(:user)
      log_in(user.id)
      expect(logged_in?).to be true
    end

    it "returns false if user is logged out" do
      expect(logged_in?).to be false
    end
  end
end
