FactoryBot.define do
  factory :batch do
    race
    number { 1 }
    track { 1 }
    time { Time.now }
  end
end
