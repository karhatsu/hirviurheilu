Then(/^the "(.*?)" text field value should be "(.*?)"$/) do |field_locator, value|
  field = find_field(field_locator)
  expect(field.value).to eql value
end
