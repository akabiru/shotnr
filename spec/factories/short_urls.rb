FactoryGirl.define do
  factory :short_url do
    vanity_string "facebook"
    user
    original_url
  end
end
