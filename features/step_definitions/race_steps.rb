Given /^there is a race with attributes:$/ do |fields|
  Factory.create(:race, fields.rows_hash)
end

Given /^there is an ongoing race with attributes:$/ do |fields|
  Factory.create(:race, {:start_date => Date.today}.merge(fields.rows_hash))
end
