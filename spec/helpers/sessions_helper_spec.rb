require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  before(:each) { session[:user_id] = user.id }

  describe "#current_user" do
    context "when session[:user_id] is nil" do
      before { session[:user_id] = nil }
      it "returns nil" do
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
      before { session[:user_id] = nil }
      it "returns false" do
        expect(logged_in?).to be false
      end
    end

    context "when logged in" do
      it "returns true" do
        expect(logged_in?).to be true
      end
    end
  end
end
