Then('I should see the current user id in the email body') do
  current_email.default_part_body.to_s.should include("Käyttäjä: #{@user.id}")
end
