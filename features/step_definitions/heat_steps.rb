Given("the race has a qualification round heat {int} with track {int} and time {string}") do |number, track, time|
  create :qualification_round_heat, race: @race, number: number, track: track, time: time
end

Given("the race has a final round heat {int} with track {int} and time {string}") do |number, track, time|
  create :final_round_heat, race: @race, number: number, track: track, time: time
end

Given('heat list generation sorts competitors by last name') do
  allow_any_instance_of(HeatList).to receive(:shuffle_competitors).and_return(@series.competitors.except(:order).order(:last_name))
end

Given('the race has a qualification and final round heat {int} with competitors assigned to track places {int}-{int}') do |heat_number, min_place, max_place|
  @series = @race.series.first || create(:series, race: @race)
  qr_heat = create :qualification_round_heat, race: @race, number: heat_number
  final_heat = create :final_round_heat, race: @race, number: heat_number
  (min_place..max_place).each do |track_place|
    create :competitor,
           series: @series,
           qualification_round_heat_id: qr_heat.id,
           qualification_round_track_place: track_place,
           final_round_heat_id: final_heat.id,
           final_round_track_place: track_place
  end
end

When("I set competitor number {int} to track place {int}") do |competitor_number, track_place|
  fill_in "track_place_#{track_place}", with: competitor_number
  script = "$('#track_place_#{track_place}').trigger('change')"
  page.execute_script(script)
end

Then("I should see heat {int} on track {int} with time {string}") do |number, track, time|
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__number'])[#{number}]")).to have_text(number)
  expect(page.find(:xpath, "(//div[@class='card']//div[@class='card__name'])[#{number}]")).to have_text("#{time} (Rata #{track})")
end

Then("the heat {int} should contain a competitor {string} in row {int}") do |number, competitor, competitor_row|
  expect(page.find(:xpath, "(//div[@class='card'])[#{number}]//div[contains(@class, 'card__middle-row')][#{competitor_row}]")).to have_text(competitor)
end

Then('the heat {int} card {int} should contain competitor {string} in the track place {int}') do |heat_number, card_number, competitor, track_place|
  card_path = "(//div[@class='row'][#{heat_number}]//a[@class='card'])[#{card_number}]"
  expect(page.find(:xpath, "#{card_path}/div[@class='card__number']")).to have_text(track_place)
  expect(page.find(:xpath, "#{card_path}/div[@class='card__middle']/div[@class='card__name']")).to have_text(competitor)
end

Then('the competitor in qualification round heat {int} on place {int} should have shots {string}') do |heat, place, shots|
  heat = @race.qualification_round_heats.where(number: heat).first
  competitor = @race.competitors.where(qualification_round_heat: heat, qualification_round_track_place: place).first
  expect(competitor.shots).to eq shots.split(', ').map(&:to_i)
end

Then('the competitor in final round heat {int} on place {int} should have shots {string}') do |heat, place, shots|
  heat = @race.final_round_heats.where(number: heat).first
  competitor = @race.competitors.where(final_round_heat: heat, final_round_track_place: place).first
  expect(competitor.shots).to eq shots.split(', ').map(&:to_i)
end
