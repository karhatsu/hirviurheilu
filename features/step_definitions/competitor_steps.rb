Given /^the series has a competitor$/ do
  @competitor = FactoryGirl.create(:competitor, :series => @series)
end

Given /^the series has a competitor "(.*?)" "(.*?)"$/ do |first_name, last_name|
  @competitor = FactoryGirl.create(:competitor, :series => @series, :first_name => first_name,
    :last_name => last_name)
end

Given /^the series has a competitor "([^"]*)" "([^"]*)" with (\d+)\+(\d+)\+(\d+) points$/ do |first_name, last_name, tpoints, epoints, spoints|
  best_time = 600
  seconds_lost = (300 - tpoints.to_i) * 10
  @competitor = FactoryGirl.create(:competitor, :series => @series, :first_name => first_name, :last_name => last_name,
    :start_time => @series.start_time, :arrival_time => @series.start_time + best_time - seconds_lost,
    :estimate1 => 100, :correct_estimate1 => 100,
    :estimate2 => 150, :correct_estimate2 => 150 - (300 - epoints.to_i) / 2,
    :shots_total_input => 100 - (600 - spoints.to_i) / 6)
  @competitor.estimate_points.should == epoints.to_i
  @competitor.shot_points.should == spoints.to_i
end

Given /^the series has (\d+) competitors$/ do |amount|
  amount.to_i.times do
    FactoryGirl.create(:competitor, :series => @series)
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
    hash[:club] = club
    hash.delete "club" # workaround for ruby 1.9
  end
  @competitor = FactoryGirl.create(:competitor, {:series => @series}.merge(hash))
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
  @competitor = FactoryGirl.create(:competitor, {:series => @series}.merge(hash))
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
  competitor.shots << Shot.new(:value => s1)
  competitor.shots << Shot.new(:value => s2)
  competitor.shots << Shot.new(:value => s3)
  competitor.shots << Shot.new(:value => s4)
  competitor.shots << Shot.new(:value => s5)
  competitor.shots << Shot.new(:value => s6)
  competitor.shots << Shot.new(:value => s7)
  competitor.shots << Shot.new(:value => s8)
  competitor.shots << Shot.new(:value => s9)
  competitor.shots << Shot.new(:value => s10)
end

Given /^someone else saves estimates (\d+) and (\d+) for the competitor$/ do |estimate1, estimate2|
  @competitor.reload
  @competitor.estimate1 = estimate1
  @competitor.estimate2 = estimate2
  @competitor.save!
end

Then /^"(.*?)" should be saved as new competitor$/ do |name|
  page.should have_content(name)
end
