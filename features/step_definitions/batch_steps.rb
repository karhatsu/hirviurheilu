Given("the race has a qualification round batch {int} with track {int} and time {string}") do |number, track, time|
  create :qualification_round_batch, race: @race, number: number, track: track, time: time
end

Given("the race has a final round batch {int} with track {int} and time {string}") do |number, track, time|
  create :final_round_batch, race: @race, number: number, track: track, time: time
end

Given('batch list generation sorts competitors by last name') do
  allow_any_instance_of(BatchList).to receive(:shuffle_competitors).and_return(@series.competitors.except(:order).order(:last_name))
end

When("I set competitor number {int} to track place {int}") do |competitor_number, track_place|
  fill_in "track_place_#{track_place}", with: competitor_number
  script = "$('#track_place_#{track_place}').trigger('change')"
  page.execute_script(script)
end

Then("I should see batch {int} on track {int} with time {string}") do |number, track, time|
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__number'])[#{number}]")).to have_text(number)
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__name'])[#{number}]")).to have_text("#{time} (Rata #{track})")
end

Then("the batch {int} should contain a competitor {string} in row {int}") do |number, competitor, competitor_row|
  expect(page.find(:xpath, "(//div[@class='card'])[#{number}]//div[contains(@class, 'card__middle-row')][#{competitor_row}]")).to have_text(competitor)
end

Then('the batch {int} card {int} should contain competitor {string} in the track place {int}') do |batch_number, card_number, competitor, track_place|
  card_path = "(//div[@class='row'][#{batch_number}]//a[@class='card'])[#{card_number}]"
  expect(page.find(:xpath, "#{card_path}/div[@class='card__number']")).to have_text(track_place)
  expect(page.find(:xpath, "#{card_path}/div[@class='card__middle']/div[@class='card__name']")).to have_text(competitor)
end
