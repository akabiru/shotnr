require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  describe "#shotlink" do
    it "returns shotlink without www" do
      link = create(:link)
      full_link = shotlink(link)
      expect(
        full_link
      ).to eq("#{root_url.sub(/www./, '')}#{link.vanity_string}")
    end
  end

  describe "#full_shotlink" do
    it "returns full shotlink" do
      link = create(:link)
      full_link = shotlink(link)
      expect(full_link).to eq("#{root_url}#{link.vanity_string}")
    end
  end
end
