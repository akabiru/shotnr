FactoryGirl.define do
  factory :user do
    provider "twitter"
    uid "123456"
    name { Faker::Name.first_name }
    image_url { Faker::Avatar.image("my-own-slug", "50x50") }
  end
end
