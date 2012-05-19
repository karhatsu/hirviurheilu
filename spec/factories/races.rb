FactoryGirl.define do
  factory :race do
    sport
    name 'Championships'
    sequence(:location) { |n| "Tervo#{n}" }
    start_date '2010-08-14'
    start_interval_seconds 60
    start_order Race::START_ORDER_BY_SERIES
    batch_size 0
    batch_interval_seconds 180
  end
end