FactoryBot.define do
  factory :club do
    race
    sequence(:name) { |n| "Ampumaseura #{n}" }
  end
end