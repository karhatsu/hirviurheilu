When('I click the card {int}') do |card_number|
  page.find(:xpath, "(//a[@class='card'])[#{card_number}]").click
end

Then('the card {int} main value should be {string}') do |order_number, main_value|
  card_locator = "//*[contains(@class, 'card')][#{order_number}]"
  expect(find(:xpath, "#{card_locator}/div[@class='card__main-value']")).to have_text(main_value)
end

Then('I should see a card {int} with number {int}, title {string} and text {string}') do |order_number, number, title, text|
  card_locator = "//div[@class='card']"
  expect(find(:xpath, "(#{card_locator})[#{order_number}]/div[@class='card__number']")).to have_text(number)
  expect(find(:xpath, "(#{card_locator})[#{order_number}]/div[@class='card__middle']/div[@class='card__name']")).to have_text(title)
  expect(find(:xpath, "(#{card_locator})[#{order_number}]/div[@class='card__middle']/div[@class='card__middle-row'][1]")).to have_text(text)
end
