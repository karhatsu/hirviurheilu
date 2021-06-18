When 'I show the shots' do
  find(:css, '#shots_button').click
end

When "I click all competitors button" do
  element = find :css, '#all_competitors_button'
  expect(element.text).to eql 'Näytä epäviralliset tulokset (kaikki kilpailijat mukana)'
  element.click
end

When "I click official competitors button" do
  element = find :css, '#all_competitors_button'
  expect(element.text).to eql 'Näytä viralliset tulokset'
  element.click
end

Then /^I should see a result row (\d+) with values:$/ do |order_number, values|
  values.rows_hash.values.each do |cell|
    step %{I should see "#{cell}" within "tr#comp_#{order_number}"}
  end
end

Then('I should see {int} as total score in the results table for row {int}') do |total_score, row|
  expect(find(:xpath, "//table[@class='results-table']/tbody/tr[#{row}]//td[contains(@class, 'total-points')]")).to have_text(total_score)
end

Then('I should see a card {int} for {string} with total score {int}') do |order_number, name, total_score|
  card_locator = "//div[contains(@class, 'result-cards')]/div[contains(@class, 'card')][#{order_number}]"
  expect(find(:xpath, "#{card_locator}/div[@class='card__middle']/div[@class='card__name']")).to have_text(name)
  expect(find(:xpath, "#{card_locator}/div[@class='card__main-value']")).to have_text(total_score)
end

Then("I should see a card {int} with {int}, {string}, {string} with points {int}") do |order_number, number, name, club, main_value|
  card_locator = "//div[contains(@class, 'result-cards')]/div[contains(@class, 'card')][#{order_number}]"
  expect(find(:xpath, "#{card_locator}/div[@class='card__number']")).to have_text(number)
  expect(find(:xpath, "#{card_locator}/div[@class='card__middle']/div[@class='card__name']")).to have_text(name)
  expect(find(:xpath, "#{card_locator}/div[@class='card__middle']/div[@class='card__middle-row'][1]")).to have_text(club)
  expect(find(:xpath, "#{card_locator}/div[@class='card__main-value']")).to have_text(main_value)
end

Then("I should see {string} in result card {int} detail row {int}") do |text, card_number, row_number|
  expect(find(:xpath, "//div[contains(@class, 'result-cards')]/div[contains(@class, 'card')][#{card_number}]//div[@class='card__middle-row'][#{row_number}]")).to have_text(text, exact: true)
end

Then('I should see the following sub results in result card {int} detail row {int}:') do |card_number, row_number, sub_results|
  parent = "//div[contains(@class, 'result-cards')]/div[contains(@class, 'card')][#{card_number}]//div[@class='card__middle-row'][#{row_number}]"
  sub_results.raw.each_with_index do |sub_result, i|
    expect(find(:xpath, "#{parent}/span[contains(@class, 'card__sub-result--#{sub_result[0]}')][#{i + 1}]")).to have_text(sub_result[1])
  end
end

Then("I should see {string} in result card {int} detail row {int} {string} result") do |text, card_number, row_number, result_type|
  expect(find(:xpath, "//div[contains(@class, 'result-cards')]/div[contains(@class, 'card')][#{card_number}]//div[@class='card__middle-row'][#{row_number}]/span[contains(@class, 'card__sub-result--#{result_type}')]")).to have_text(text, exact: true)
end

Then /^I should see a team (\d+) competitor row (\d+) with values:$/ do |team_order_number,
    competitor_order_number, values|
  values.rows_hash.values.each do |cell|
    step %{I should see "#{cell}" within "tr#team_#{team_order_number}_comp_#{competitor_order_number}"}
  end
end

Then /^the result row (\d+) should have time "(.*?)" with reference time "(.*?)"$/ do |row, time, comparison_time|
  find(:xpath, "//tr[@id='comp_#{row}']//td[@title='Vertailuaika: #{comparison_time}']").should have_content(time)
end
