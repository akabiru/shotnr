require "rails_helper"

RSpec.describe Link, type: :model do
  it { should validate_presence_of(:actual) }

  before(:each) { @link = build(:link) }

  describe "#increment_clicks" do
    it "is expected to increment clicks" do
      expect(@link.clicks).to eq 0
      @link.increment_clicks
      expect(@link.clicks).to eq 1
    end
  end

  describe "#active?" do
    it "returns boolean active state" do
      expect(@link.active?).to be true
      @link.update(active: false)
      expect(@link.active?).to be false
    end
  end

  describe '#ours?' do
    it "return boolean state of whether actual link is ours" do
      expect(@link.ours?).to be false
      @link.actual = "http://shotnr.com"
      expect(@link.ours?).to be true
    end
  end
end
