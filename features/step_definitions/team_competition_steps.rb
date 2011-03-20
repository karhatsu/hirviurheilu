Given /^the race has a team competition "([^"]*)" with (\d+) competitors \/ team$/ do |name, count|
  @tc = Factory.create(:team_competition, :race => @race, :name => name,
    :team_competitor_count => count)
end

Given /^the team competition contains the series "([^"]*)"$/ do |series_name|
  @tc.series << @race.series.find_by_name(series_name)
end