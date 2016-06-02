require "rails_helper"

RSpec.describe Link, type: :model do
  it { should validate_presence_of(:actual) }

  let(:link) { build(:link) }

  describe "#increment_clicks" do
    it "increments clicks" do
      link_clicks = link.clicks
      link.increment_clicks
      expect(link.clicks).to eq(link_clicks + 1)
    end
  end

  describe "#active?" do
    context "when a link is created" do
      it "returns active as true" do
        expect(link.active).to be true
      end
    end

    context "when a link is inactive" do
      it "returns active as false" do
        link.update(active: false)
        expect(link.active).to be false
      end
    end
  end

  describe '#ours?' do
    context "when the link is ours" do
      it "returns true" do
        link.update(actual: "http://shotnr.com")
        expect(link.ours?).to be true
      end
    end

    context "when the link is not ours" do
      it "returns false" do
        expect(link.ours?).to be false
      end
    end
  end
end
