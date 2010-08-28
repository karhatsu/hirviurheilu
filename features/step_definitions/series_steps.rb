Given /^the race has series with attributes:$/ do |fields|
  Factory.create(:series, {:race => @race}.merge(fields.rows_hash))
end
