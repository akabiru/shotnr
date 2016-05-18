FactoryGirl.define do
  factory :link do
    actual "https://www.facebook.com"
    vanity_string "facebook"
    clicks 0
    active true
    user
  end
end
