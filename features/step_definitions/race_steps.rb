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

Given /^there is an ongoing race with attributes:$/ do |fields|
  @race = Factory.create(:race, {:start_date => Date.today}.merge(fields.rows_hash))
end

Given /^the race is finished$/ do
  @race.finish!
end
