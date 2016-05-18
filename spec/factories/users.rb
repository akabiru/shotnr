FactoryGirl.define do
  factory :user do
    provider "twitter"
    uid "123456"
    name { Faker::Name.first_name }
    image_url { Faker::Avatar.image("my-own-slug", "50x50") }

    factory :user_with_links do
      transient do
        link_count 1
      end

      after(:create) do |user, evaluator|
        create_list(:link, evaluator.link_count, user: user)
      end
    end
  end
end
