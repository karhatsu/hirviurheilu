Given /^the race has a team competition "([^"]*)" with (\d+) competitors \/ team$/ do |name, count|
  @tc = create(:team_competition, :race => @race, :name => name,
    :team_competitor_count => count)
end

Given /^the race has a team name based team competition "([^"]*)" with (\d+) competitors \/ team$/ do |name, count|
  @tc = create(:team_competition, :race => @race, :name => name,
    :team_competitor_count => count, :use_team_name => true)
end

Given /^the team competition contains the series "([^"]*)"$/ do |series_name|
  @tc.series << @race.series.find_by_name(series_name)
end

Given /^the team competition contains the age group "([^"]*)"$/ do |age_group_name|
  @tc.age_groups << @race.age_groups.find_by_name(age_group_name)
end