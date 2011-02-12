Given /^there is a race with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:sport] == 'SKI'
    hash.delete("sport")
    hash[:sport] = Sport.find_ski
  elsif hash[:sport] == 'RUN'
    hash.delete("sport")
    hash[:sport] = Sport.find_run
  elsif hash[:sport]
    raise "Unknown sport key: #{hash[:sport]}"
  end
  @race = Factory.create(:race, hash)
end

Given /^I have a race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :name => name)
  @user.races << @race
end

Given /^I have a race with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:sport] == 'SKI'
    hash.delete("sport")
    hash[:sport] = Sport.find_ski
  elsif hash[:sport] == 'RUN'
    hash.delete("sport")
    hash[:sport] = Sport.find_run
  elsif hash[:sport]
    raise "Unknown sport key: #{hash[:sport]}"
  end
  @race = Factory.create(:race, hash)
  @user.races << @race
end

Given /^there is an ongoing race with attributes:$/ do |fields|
  @race = Factory.create(:race, {:start_date => Date.today}.merge(fields.rows_hash))
end

Given /^the race is finished$/ do
  @race.reload
  @race.finish!
end

Given /^I have an ongoing race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :start_date => Date.today, :name => name,
    :sport => Sport.find_ski)
  @user.races << @race
end

Given /^I have a future race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :start_date => Date.today + 1, :name => name)
  @user.races << @race
end
