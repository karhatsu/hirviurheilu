Given /^the race has series with attributes:$/ do |fields|
  @series = Factory.create(:series, {:race => @race}.merge(fields.rows_hash))
end

Given /^there are numbers generated for the series$/ do
  @series.generate_numbers!
end

Given /^there are start times generated for the series$/ do
  @series.generate_start_times!
end
