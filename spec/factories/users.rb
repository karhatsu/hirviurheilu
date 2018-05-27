FactoryBot.define do
  factory :user do
    first_name 'Tom'
    last_name 'Testerson'
    club_name 'Test club'
    sequence(:email) { |n| "test#{n}@test.com" }
    password 'test_password'
    password_confirmation 'test_password'
  end
end