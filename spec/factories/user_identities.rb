FactoryBot.define do
  factory :user_identity do
    user
    provider { :discord }
    sequence(:uid) { |n| "uid#{n}" }
    workspace_id { nil }
  end
end
