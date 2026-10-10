FactoryBot.define do
  factory :event do
    sequence(:public_token) { |n| "token#{n}" }
    sequence(:title) { |n| "イベント#{n}" }
    granularity { :date }
    editable_by_anyone { true }
  end
end
