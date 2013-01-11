FactoryGirl.define do
  factory :competitor do
    club
    series
    sequence(:first_name) { |n| "Tauno #{n}" }
    last_name 'Miettinen'
    sequence(:number) { |n| n }
  end
end