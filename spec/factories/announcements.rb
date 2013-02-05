FactoryGirl.define do
  factory :announcement do
    published Date.today
    title 'Hello elks!'
    content 'News about elks'
    active true
  end
end