FactoryGirl.define do
  factory :user do
    provider 'twitter'
    uid '123456'
    name { Faker::Name.first_name }
    image_url { Faker::Avatar.image("my-own-slug", "50x50") }

    factory :user_with_short_urls do
      transient do
        short_url_count 1
      end

      after(:create) do |user, evaluator|
        create_list(:short_url, evaluator.short_url_count, user: user)
      end
    end
  end
end
