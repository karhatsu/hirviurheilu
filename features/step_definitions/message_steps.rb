Then /^I should see "(.*?)" in an? (info|error|success|warning) message$/ do |msg, type|
  within("div.#{type}") do
    page.should have_content(msg)
  end
end
