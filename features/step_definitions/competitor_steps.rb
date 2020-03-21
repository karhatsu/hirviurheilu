Given "the series has a competitor" do
  @competitor = create(:competitor, :series => @series)
end

Given "the series has a competitor {int} {string} {string} from {string}" do |number, first_name, last_name, club_name|
  club = Club.find_or_create_by race: @race, name: club_name
  @competitor = create :competitor, series: @series, club: club, number: number, first_name: first_name, last_name: last_name
end

Given "the series has a competitor {string} {string}" do |first_name, last_name|
  @competitor = create(:competitor, :series => @series, :first_name => first_name,
    :last_name => last_name)
end

Given("the series has a competitor {int} {string} {string} from {string} with shots {string}") do |number, first_name, last_name, club_name, shots|
  club = Club.find_or_create_by race: @race, name: club_name
  @competitor = create :competitor, series: @series, club: club, number: number, first_name: first_name, last_name: last_name, shots: shots.split(',')
end

Given /^the series has a competitor "([^"]*)" "([^"]*)" with (\d+)\+(\d+)\+(\d+) points$/ do |first_name, last_name, tpoints, epoints, spoints|
  best_time = 600
  seconds_lost = (300 - tpoints.to_i) * 10
  @competitor = create(:competitor, :series => @series, :first_name => first_name, :last_name => last_name,
    :start_time => @series.start_time, :arrival_time => @series.start_time + best_time - seconds_lost,
    :estimate1 => 100, :correct_estimate1 => 100,
    :estimate2 => 150, :correct_estimate2 => 150 - (300 - epoints.to_i) / 2,
    :shooting_score_input => 100 - (600 - spoints.to_i) / 6)
  @competitor.estimate_points.should == epoints.to_i
  @competitor.shooting_points.should == spoints.to_i
end

Given /^the series has a competitor with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    hash[:club_id] = club.id
    hash.delete "club" # workaround for ruby 1.9
  end
  if hash[:qualification_round_batch]
    batch = QualificationRoundBatch.where(race: @race.id, number: hash[:qualification_round_batch]).first
    hash[:qualification_round_batch_id] = batch.id
    hash.delete "qualification_round_batch"
  end
  if hash[:final_round_batch]
    batch = FinalRoundBatch.where(race: @race.id, number: hash[:final_round_batch]).first
    hash[:final_round_batch_id] = batch.id
    hash.delete "final_round_batch"
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
  find(:xpath, "(#{parent})[#{card}]//div[@class='card__number']").should have_text(number)
  find(:xpath, "(#{parent})[#{card}]//div[@class='card__name']").should have_text(name)
  find(:xpath, "(#{parent})[#{card}]//div[@class='card__middle-row'][2]").should have_text(start_time)
end
