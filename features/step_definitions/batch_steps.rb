Given("the race has a batch {int} with track {int} and time {string}") do |number, track, time|
  create :batch, race: @race, number: number, track: track, time: time
end

Then("I should see batch {int} on track {int} with time {string}") do |number, track, time|
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__number'])[#{number}]")).to have_text(number)
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__name'])[#{number}]")).to have_text("Rata #{track}")
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__main-value'])[#{number}]")).to have_text(time)
end

Then("the batch {int} should contain a competitor {string} in row {int}") do |number, competitor, competitor_row|
  expect(page.find(:xpath, "(//div[@class='card'])[#{number}]//div[@class='card__middle-1'][#{competitor_row}]")).to have_text(competitor)
end
