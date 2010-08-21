Factory.define :user do |u|
  u.first_name 'Tom'
  u.last_name 'Testerson'
  u.email 'test@test.com'
  u.password 'test_password'
  u.password_confirmation 'test_password'
end