Then /^the page title should contain "(.*?)"$/ do |title|
  expect(page).to have_css(".body__on-top-title", text: title)
end
