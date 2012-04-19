Given /^the race has series "([^*]*)"$/ do |name|
  @series = FactoryGirl.create(:series, :race => @race, :name => name)
end

Given /^the race has series with attributes:$/ do |fields|
  @series = FactoryGirl.create(:series, {:race => @race}.merge(fields.rows_hash))
end