FactoryBot.define do
  factory :slot do
    event
    sequence(:start_at) { |n| Time.zone.local(2026, 10, 1) + n.days }
    end_at { start_at + 1.day }
  end
end
