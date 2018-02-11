Given(/^there is a district "([^"]*)"$/) do |district_name|
  @district = create :district, name: district_name
end
