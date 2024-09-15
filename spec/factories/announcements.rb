FactoryBot.define do
  factory :announcement do
    published { Date.today }
    title { 'Hello elks!' }
    markdown { 'News about *elks*' }
    active { true }
  end
end
