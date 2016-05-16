require "rails_helper"

RSpec.describe ShortUrl, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:original_url) }
  it { should validate_presence_of(:original_url_id) }
  it { should validate_presence_of(:vanity_string) }
  it { should accept_nested_attributes_for(:original_url) }

  describe "#generate_short_url" do
    it 'generates short url vanity string' do
      user = create(:user_with_short_urls)
      expect(user.short_urls.first.vanity_string).to eq 'facebook'
      user.short_urls.first.generate_short_url
      expect(user.short_urls.first.vanity_string).to eq '6'
    end
  end
end
