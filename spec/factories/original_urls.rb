FactoryGirl.define do
  factory :original_url do
    long_url "https://www.facebook.com"
    clicks 0
    active true
  end
end
