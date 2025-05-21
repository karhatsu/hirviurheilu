Then(/^the "(.*?)" text field value should be "(.*?)"$/) do |field_locator, value|
  field = find_field(field_locator)
  expect(field.value).to eql value
end

Then('the input field {int} value should be {string}') do |order_no, value|
  expect(page).to have_selector('input', minimum: order_no)
  expect(all('input')[order_no - 1].value).to eq(value)
end
