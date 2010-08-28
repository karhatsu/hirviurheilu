Given /^there is a race with attributes:$/ do |fields|
  Factory.create(:race, fields.rows_hash)
end
