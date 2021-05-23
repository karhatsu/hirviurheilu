When 'I show the shots' do
  find(:css, '#show-shots-button').click
end

Then /^I should see a result row (\d+) with values:$/ do |order_number, values|
  values.rows_hash.values.each do |cell|
    step %{I should see "#{cell}" within "tr#comp_#{order_number}"}
  end
end

Then('I should see {int} as total score in the results table for row {int}') do |total_score, row|
  expect(find(:xpath, "//table[@class='results-table']/tbody/tr[#{1 + row}]//td[contains(@class, 'total-points')]")).to have_text(total_score)
end

Then('I should see a card {int} for {string} with total score {int}') do |order_number, name, total_score|
  card_locator = "//div[@class='result-cards']/div[contains(@class, 'card')][#{order_number}]"
  expect(find(:xpath, "#{card_locator}/div[@class='card__middle']/div[@class='card__name']")).to have_text(name)
  expect(find(:xpath, "#{card_locator}/div[@class='card__main-value']")).to have_text(total_score)
end

Then("I should see a card {int} with {int}, {string}, {string} with points {int}") do |order_number, number, name, club, main_value|
  card_locator = "//div[@class='result-cards']/div[contains(@class, 'card')][#{order_number}]"
  expect(find(:xpath, "#{card_locator}/div[@class='card__number']")).to have_text(number)
  expect(find(:xpath, "#{card_locator}/div[@class='card__middle']/div[@class='card__name']")).to have_text(name)
  expect(find(:xpath, "#{card_locator}/div[@class='card__middle']/div[@class='card__middle-row'][1]")).to have_text(club)
  expect(find(:xpath, "#{card_locator}/div[@class='card__main-value']")).to have_text(main_value)
end

Then("I should see {string} in result card {int} detail row {int}") do |text, card_number, row_number|
  expect(find(:xpath, "//div[@class='result-cards']/div[contains(@class, 'card')][#{card_number}]//div[@class='card__middle-row'][#{row_number}]")).to have_text(text, exact: true)
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

Then(/^I should see individual competitor page points (\d+)\+(\d+)\+(\d+)=(\d+)$/) do |shooting_points, estimate_points, time_points, total_points|
  expect(find("#shooting_points")).to have_text(shooting_points)
  expect(find("#estimate_points")).to have_text(estimate_points)
  expect(find("#time_points")).to have_text(time_points)
  expect(find("#total_points")).to have_text(total_points)
end

Then(/^I should see individual competitor page points (\d+)\+(\d+)=(\d+) without time points$/) do |shooting_points, estimate_points, total_points|
  expect(find("#shooting_points")).to have_text(shooting_points)
  expect(find("#estimate_points")).to have_text(estimate_points)
  expect(find("#total_points")).to have_text(total_points)
  expect(page).to have_no_text(300)
end

Then(/^I should see individual competitor page time result "(.*?)"\-"(.*?)"="(.*?)"$/) do |start_time, arrival_time, total_time|
  expect(find("#start_time")).to have_text(start_time)
  expect(find("#arrival_time")).to have_text(arrival_time)
  expect(find("#total_time")).to have_text(total_time)
end

Then(/^I should see at individual competitor page estimates (\d+) and (\d+) with correct estimates (\d+) and (\d+) with distance error "(.*?)" and "(.*?)"$/) do |estimate1,
    estimate2, correct_estimate1, correct_estimate2, distance_error1, distance_error2|
  expect(find("#estimate1")).to have_text(estimate1)
  expect(find("#estimate2")).to have_text(estimate2)
  expect(find("#correct_estimate1")).to have_text(correct_estimate1)
  expect(find("#correct_estimate2")).to have_text(correct_estimate2)
  expect(find("#distance_error1")).to have_text(distance_error1)
  expect(find("#distance_error2")).to have_text(distance_error2)
end

Then(/^I should see at individual competitor page estimates (\d+), (\d+), (\d+) and (\d+) with correct estimates (\d+), (\d+), (\d+) and (\d+) with distance error "(.*?)", "(.*?)", "(.*?)" and "(.*?)"$/) do |estimate1,
    estimate2, estimate3, estimate4, correct_estimate1, correct_estimate2, correct_estimate3, correct_estimate4, distance_error1, distance_error2, distance_error3, distance_error4|
  expect(find("#estimate1")).to have_text(estimate1)
  expect(find("#estimate2")).to have_text(estimate2)
  expect(find("#estimate3")).to have_text(estimate3)
  expect(find("#estimate4")).to have_text(estimate4)
  expect(find("#correct_estimate1")).to have_text(correct_estimate1)
  expect(find("#correct_estimate2")).to have_text(correct_estimate2)
  expect(find("#correct_estimate3")).to have_text(correct_estimate3)
  expect(find("#correct_estimate4")).to have_text(correct_estimate4)
  expect(find("#distance_error1")).to have_text(distance_error1)
  expect(find("#distance_error2")).to have_text(distance_error2)
  expect(find("#distance_error3")).to have_text(distance_error3)
  expect(find("#distance_error4")).to have_text(distance_error4)
end

Then(/^I should not see (\d+), (\d+), (\d+), (\d+), "(.*?)" or "(.*?)" in individual competitor page estimates$/) do |estimate1, estimate2, correct_estimate1, correct_estimate2, distance_error1, distance_error2|
  expect(page).to have_no_text(estimate1)
  expect(page).to have_no_text(estimate2)
  expect(page).to have_no_text(correct_estimate1)
  expect(page).to have_no_text(correct_estimate2)
  expect(page).to have_no_text(distance_error1)
  expect(page).to have_no_text(distance_error2)
end
