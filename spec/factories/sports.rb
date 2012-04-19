FactoryGirl.define do
  factory :sport do
    name 'Hirvenjuoksu'
    sequence(:key) {|n| "key #{n}"}
  end
end