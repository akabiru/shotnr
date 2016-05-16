require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:short_urls) }
  it { is_expected.to have_many(:original_urls).through(:short_urls) }

  describe '#increment_total_clicks' do
    it "increments total clicks" do
      user = build(:user, uid: 45_679)
      expect(user.total_clicks).to eq 0
      user.increment_total_clicks
      expect(user.total_clicks).to eq 1
      expect(user.new_record?).to be false
    end
  end

  describe '#trending_shotlink' do
    it "gets the trending shotlink" do
      user = create(:user_with_short_urls)
      expect(user.trending_shotlink[:clicks]).to eq 0
      user.short_urls.first.original_url.increment_clicks
      expect(user.trending_shotlink[:clicks]).to eq 1
    end
  end

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
