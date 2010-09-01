Given /^I am an official with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  Factory.create(:role, :name => Role::OFFICIAL)
  @user = Factory.create(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.add_official_rights
end
