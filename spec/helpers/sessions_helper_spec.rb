require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  before(:each) { log_in(user.id) }

  describe "#login_in" do
    it "sets the session[:user_id] to current_user.id" do
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "#logout" do
    it "clears the session" do
      logout
      expect(session[:user_id]).to be nil
      expect(assigns(:current_user)).to be nil
    end
  end

  describe "#current_user" do
    context "when session[:user_id] is nil" do
      it "returns nil" do
        logout
        expect(current_user).to be_nil
      end
    end

    context "when session[:user_id] is present" do
      it "returns the current user" do
        expect(current_user.id).to eq(user.id)
      end
    end
  end

  describe "#logged_in?" do
    context "when logged out" do
      before { logout }
      it "returns true" do
        expect(logged_in?).to be false
      end
    end

    context "when logged in" do
      it "returns false" do
        expect(logged_in?).to be true
      end
    end
  end
end
