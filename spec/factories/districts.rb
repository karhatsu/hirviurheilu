FactoryBot.define do
  factory :district do
    sequence(:name) { |n| "Test district #{n}" }
    sequence(:short_name) { |n| "TD#{n}" }
  end
end