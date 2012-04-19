Given /^the race has correct estimates with attributes:$/ do |fields|
  FactoryGirl.create(:correct_estimate, {:race => @race}.merge(fields.rows_hash))
end
