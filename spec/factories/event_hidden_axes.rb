FactoryBot.define do
  factory :event_hidden_axis do
    event
    axis_kind { :date }
    sequence(:hidden_date) { |n|Date.new(2026, 10, 1) + n }

    trait :time_band do
      axis_kind { :time_band }
      hidden_date { nil }
      sequence(:hidden_start_time) { |n| format("%02d:00", n % 23) }
      sequence(:hidden_end_time) { |n| format("%02d:30", n % 23) }
    end
  end
end
