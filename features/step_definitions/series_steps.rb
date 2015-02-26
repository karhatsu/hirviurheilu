Given /^the race has series "([^*]*)"$/ do |name|
  @series = create(:series, :race => @race, :name => name)
end

Given /^the race has a series "(.*?)" with first number (\d+) and start time "(.*?)"$/ do |name, first_number, start_time|
  @series = create(:series, :race => @race, :name => name, :first_number => first_number,
    :start_time => start_time)
end

Given /^the race has series with attributes:$/ do |fields|
  @series = create(:series, {:race => @race}.merge(fields.rows_hash))
end