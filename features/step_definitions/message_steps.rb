Then /^I should see "(.*?)" in an? (info|error|success|warning) message$/ do |msg, type|
  within(".message.message--#{type}") do
    page.should have_content(msg)
  end
end

Then /^I should see "(.*?)" in the second (info|error|success|warning) message$/ do |msg, type|
  within(:xpath, "//div[@class='message message--#{type}'][2]") do
    page.should have_content(msg)
  end
end
