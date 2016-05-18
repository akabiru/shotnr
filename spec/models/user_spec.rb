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
end
