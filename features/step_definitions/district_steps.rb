Given(/^there is a district "([^"]*)"$/) do |district_name|
  @district = create :district, name: district_name
end

Given(/^there is a district "([^"]*)" with short name "([^"]*)"$/) do |name, short_name|
  @district = create :district, name: name, short_name: short_name
end
