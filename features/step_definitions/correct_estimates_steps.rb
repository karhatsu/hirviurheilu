Given /^the race has correct estimates with attributes:$/ do |fields|
  Factory.create(:correct_estimate, {:race => @race}.merge(fields.rows_hash))
end
