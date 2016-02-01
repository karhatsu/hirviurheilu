When(/^I fill the ask for an offer form$/) do
  @name = 'Timo Testinen'
  @email = 'sender@test.com'
  @tel = '123 456'
  @club = 'Testiseura'
  @competition_info = 'We have 5 races this year.'
  fill_in 'Nimi', with: @name
  fill_in 'Sähköposti', with: @email
  fill_in 'Puhelin', with: @tel
  fill_in 'Seura', with: @club
  fill_in 'Tietoa kilpailuista', with: @competition_info
  click_button 'Lähetä'
end

Then(/^the email body should contain the offer information$/) do
  expect_email_text "Nimi: #{@name}"
  expect_email_text "Sähköposti: #{@email}"
  expect_email_text "Puhelin: #{@tel}"
  expect_email_text "Seura: #{@club}"
  expect_email_text @competition_info
end

Then(/^the email sender should be the offer sender$/) do
  current_email.should be_delivered_from(@email)
end

def expect_email_text(text)
  current_email.default_part_body.to_s.should include(text)
end
