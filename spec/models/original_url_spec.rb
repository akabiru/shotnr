require "rails_helper"

RSpec.describe OriginalUrl, type: :model do
  it { should have_one(:short_url) }
  it { should validate_presence_of(:long_url) }

  before(:each) { @original_url = build(:original_url) }

  describe "#increment_clicks" do
    it "is expected to increment clicks" do
      expect(@original_url.clicks).to eq 0
      @original_url.increment_clicks
      expect(@original_url.clicks).to eq 1
    end
  end

  describe "#active?" do
    it "returns boolean active state" do
      expect(@original_url.active?).to be true
      @original_url.update_attributes(active: false)
      expect(@original_url.active?).to be false
    end
  end

  describe "#inactive?" do
    it "return boolean inactive state" do
      expect(@original_url.inactive?).to be false
      @original_url.update_attributes(active: false)
      expect(@original_url.inactive?).to be true
    end
  end

  describe ".find_long_url" do
    it "given vanity string returns original_url otherwise false" do
      user = create(:user_with_short_urls)
      expect(OriginalUrl.count).to eq 1
      original_url = OriginalUrl.find_long_url("facebook")
      expect(original_url).to eq user.original_urls.first
      original_url = OriginalUrl.find_long_url("none")
      expect(original_url).to be false
    end
  end
end
