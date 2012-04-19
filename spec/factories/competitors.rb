FactoryGirl.define do
  factory :competitor do
    club
    series
    first_name 'Tauno'
    last_name 'Miettinen'
    sequence(:number) { |n| n }
  end
end