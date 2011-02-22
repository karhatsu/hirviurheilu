Given /^there exists an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  user = Factory.create(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  user.add_official_rights
end

Given /^there is an official with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  user = Factory.create(:user, :email => email, :password => password,
    :password_confirmation => password)
  user.add_official_rights
end

Given /^there is an official "([^"]*)" "([^"]*)" with email "([^"]*)" and password "([^"]*)"$/ do |first_name,
    last_name, email, password|
  user = Factory.create(:user, :email => email, :password => password,
    :password_confirmation => password, :first_name => first_name,
    :last_name => last_name)
  user.add_official_rights
end

Given /^I am an official$/ do
  @user = Factory.create(:user)
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)"$/ do |email|
  @user = Factory.create(:user, :email => email)
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  @user = Factory.create(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)" and password "([^"]*)"$/ do |firstname,
    lastname, email, pw|
  @user = Factory.create(:user, :first_name => firstname, :last_name => lastname,
    :email => email, :password => pw, :password_confirmation => pw)
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = Factory.create(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.add_official_rights
end

Given /^I am an official with attributes:$/ do |fields|
  @user = Factory.create(:user, fields.rows_hash)
  @user.add_official_rights
end

Given /^I am an admin$/ do
  @user = Factory.create(:user)
  @user.add_admin_rights
end

Given /^I am an admin with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = Factory.create(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.add_admin_rights
end

Given /^I have logged in$/ do
  visit login_path
  fill_in("Sähköposti", :with => @user.email)
  fill_in("Salasana", :with => @user.password)
  click_button("Kirjaudu")
end
