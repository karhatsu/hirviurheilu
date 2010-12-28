Given /^the race has series "([^*]*)"$/ do |name|
  @series = Factory.create(:series, :race => @race, :name => name)
end

Given /^the race has series with attributes:$/ do |fields|
  @series = Factory.create(:series, {:race => @race}.merge(fields.rows_hash))
end