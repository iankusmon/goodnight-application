FactoryBot.define do
  factory :sleep_session do
    slept_at { 8.hours.ago }
    woke_at { Time.current }
    association :user
  end
end
