FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Article Title #{n}" }
    content { "This is valid article content with enough length." }
    association :author, factory: :user
    published { false }

    trait :published do
      published { true }
      published_at { Time.current }
    end
  end
end
