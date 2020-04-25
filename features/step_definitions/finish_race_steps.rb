When("I choose {string} for the competitor on finish race") do |action|
  choose "competitor_#{@competitor.id}_#{action}"
end

And("series {string} should be finished") do |series_name|
  expect(Series.find_by_name(series_name).finished).to be_truthy
end

And("series {string} should not be finished") do |series_name|
  expect(Series.find_by_name(series_name).finished).to be_falsey
end

And("the race should not be finished") do
  expect(@race.reload.finished).to be_falsey
end
