Factory.sequence :user_email do |i|
  "test#{i}@test.com"
end

Factory.define :user do |u|
  u.first_name 'Tom'
  u.last_name 'Testerson'
  u.email { Factory.next(:user_email) }
  u.password 'test_password'
  u.password_confirmation 'test_password'
end