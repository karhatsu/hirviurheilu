Given /^the series has a competitor$/ do
  @competitor = create(:competitor, :series => @series)
end

Given /^the series has a competitor "(.*?)" "(.*?)"$/ do |first_name, last_name|
  @competitor = create(:competitor, :series => @series, :first_name => first_name,
    :last_name => last_name)
end

Given /^the series has a competitor "([^"]*)" "([^"]*)" with (\d+)\+(\d+)\+(\d+) points$/ do |first_name, last_name, tpoints, epoints, spoints|
  best_time = 600
  seconds_lost = (300 - tpoints.to_i) * 10
  @competitor = create(:competitor, :series => @series, :first_name => first_name, :last_name => last_name,
    :start_time => @series.start_time, :arrival_time => @series.start_time + best_time - seconds_lost,
    :estimate1 => 100, :correct_estimate1 => 100,
    :estimate2 => 150, :correct_estimate2 => 150 - (300 - epoints.to_i) / 2,
    :shots_total_input => 100 - (600 - spoints.to_i) / 6)
  @competitor.estimate_points.should == epoints.to_i
  @competitor.shot_points.should == spoints.to_i
end

Given /^the series has (\d+) competitors$/ do |amount|
  amount.to_i.times do
    create(:competitor, :series => @series)
  end
end

# This is against the principles of integration tests but
# big count slows down the tests too much.
Given /^the database contains in total (\d+) competitors$/ do |count|
  Competitor.stub(:count).and_return(count.to_i)
end

Given /^the series has a competitor with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    hash[:club_id] = club.id
    hash.delete "club" # workaround for ruby 1.9
  end
  if hash[:batch]
    batch = Batch.where(race: @race.id, number: hash[:batch]).first
    hash[:batch_id] = batch.id
    hash.delete "batch"
  end
  @competitor = create(:competitor, {:series => @series}.merge(hash))
end

Given /^the series "([^"]*)" contains a competitor with attributes:$/ do |series_name, fields|
  @series = Series.find_by_name(series_name)
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    club = Club.create!(:race => @series.race, :name => hash[:club]) unless club
    hash[:club] = club
    hash.delete "club" # workaround for ruby 1.9
  end
  @competitor = create(:competitor, {:series => @series}.merge(hash))
end

Given /^the competitor belongs to an age group "([^"]*)"$/ do |age_group_name|
  @competitor.age_group = AgeGroup.find_by_name(age_group_name)
  @competitor.save!
end

Given /^the competitor "([^"]*)" "([^"]*)" has the following results:$/ do |first_name,
    last_name, fields|
  competitor = Competitor.where(['first_name=? and last_name=?', first_name, last_name]).first
  competitor.attributes = fields.rows_hash
  competitor.save!
end

Given /^the shots for the competitor "([^"]*)" "([^"]*)" are (\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+)$/ do |first_name,
    last_name, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10|
  competitor = Competitor.where(['first_name=? and last_name=?', first_name, last_name]).first
  competitor.shot_0 = s1
  competitor.shot_1 = s2
  competitor.shot_2 = s3
  competitor.shot_3 = s4
  competitor.shot_4 = s5
  competitor.shot_5 = s6
  competitor.shot_6 = s7
  competitor.shot_7 = s8
  competitor.shot_8 = s9
  competitor.shot_9 = s10
  competitor.save!
end

Given /^someone else saves estimates (\d+) and (\d+) for the competitor$/ do |estimate1, estimate2|
  @competitor.reload
  @competitor.estimate1 = estimate1
  @competitor.estimate2 = estimate2
  @competitor.save!
end

When(/^I update the first competitor values to "(.*?)"\/"(.*?)", "(.*?)", "(.*?)", "(.*?)", "(.*?)", (\d+) in start list page$/) do |series_name,
    age_group_name, first_name, last_name, club_name, start_time, number|
  within(:xpath, "//div[@class='competitor_row'][2]") do
    select series_name, from: "competitor_#{@competitor.id}_competitor_series_id"
    select age_group_name, from: 'competitor[age_group_id]'
    fill_in "competitor_#{@competitor.id}_competitor_first_name", with: first_name
    fill_in "competitor_#{@competitor.id}_competitor_last_name", with: last_name
    fill_in "competitor_#{@competitor.id}_competitor_start_time", with: start_time
    fill_in "competitor_#{@competitor.id}_competitor_number", with: number
    fill_in "club_name_#{@competitor.id}", with: club_name
  end
end

Then("I should see competitor {int} {string} with start time {string} in card {int}") do |number, name, start_time, card|
  parent = "//a[@class='card']"
  find(:xpath, "(#{parent}//div[@class='card__number'])[#{card}]").should have_text(number)
  find(:xpath, "(#{parent}//div[@class='card__name'])[#{card}]").should have_text(name)
  find(:xpath, "(#{parent}//div[@class='card__middle-2'])[#{card}]").should have_text(start_time)
end
