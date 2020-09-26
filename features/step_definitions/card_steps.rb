When('I click the card {int}') do |card_number|
  page.find(:xpath, "(//a[@class='card'])[#{card_number}]").click
end

Then('the card {int} main value should be {string}') do |order_number, main_value|
  card_locator = "//*[contains(@class, 'card')][#{order_number}]"
  expect(find(:xpath, "#{card_locator}/div[@class='card__main-value']")).to have_text(main_value)
end
