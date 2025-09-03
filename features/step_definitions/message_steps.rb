Then /^I should see "(.*?)" in an? (info|error|success|warning) message$/ do |msg, type|
  expect(page).to have_css(".message.message--#{type}", text: msg)
end
