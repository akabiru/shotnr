require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:links) }

  describe ".from_omni_auth" do
    context "existing user" do
      it "should find the user" do
        create(:user)
        expect do
          User.from_omni_auth(valid_attributes_omniauth)
        end.to change(User, :count).by(0)
      end
    end

    context "new user" do
      it "should create the user" do
        expect do
          User.from_omni_auth(valid_attributes_omniauth)
        end.to change(User, :count).by(1)
      end
    end

    def new_valid_attributes_omniauth
      user_hash = attributes_for(:user, uid: 456)
      attributes_omniauth(user_hash)
    end

    def valid_attributes_omniauth
      user_hash = attributes_for(:user)
      attributes_omniauth(user_hash)
    end

    def attributes_omniauth(user_hash)
      {
        "provider" => user_hash[:provider],
        "uid" => user_hash[:uid],
        "info" => {
          "name" => user_hash[:name],
          "image" => user_hash[:image_url],
          "urls" => {
            "Twitter" => Faker::Internet.url
          }
        }
      }
    end
  end

  describe ".top_users" do
    it "should return top users ordered by total_clicks" do
      user_1 = create(:user, uid: 123)
      user_2 = create(:user, uid: 234)
      create(:link, vanity_string: "q", clicks: 2, user: user_1)
      create(:link, vanity_string: "e", clicks: 4, user: user_1)
      create(:link, vanity_string: "r", clicks: 1, user: user_2)
      create(:link, vanity_string: "t", clicks: 3, user: user_2)
      expect(User.top_users.first["name"]).to eq(user_1.name)
      expect(User.top_users[1]["name"]).to eq(user_2.name)
    end
  end
end
