FactoryBot.define do
  factory :participant do
    event
    sequence(:name) { |n| "参加者#{n}" }
    responded_at { nil }
  end
end
