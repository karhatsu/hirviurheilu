Given /^there exists an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  user = Factory.build(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  user = Factory.build(:user, :email => email, :password => password,
    :password_confirmation => password)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official "([^"]*)" "([^"]*)" with email "([^"]*)" and password "([^"]*)"$/ do |first_name,
    last_name, email, password|
  user = Factory.build(:user, :email => email, :password => password,
    :password_confirmation => password, :first_name => first_name,
    :last_name => last_name)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^I am an official$/ do
  @user = Factory.build(:user)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)"$/ do |email|
  @user = Factory.build(:user, :email => email)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) ([a-zA-Z]*)"$/ do |firstname, lastname|
  @user = Factory.build(:user, :first_name => firstname, :last_name => lastname)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  @user = Factory.build(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)" and password "([^"]*)"$/ do |firstname,
    lastname, email, pw|
  @user = Factory.build(:user, :first_name => firstname, :last_name => lastname,
    :email => email, :password => pw, :password_confirmation => pw)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = Factory.build(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with attributes:$/ do |fields|
  @user = Factory.build(:user, fields.rows_hash)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an admin$/ do
  @user = Factory.build(:user)
  @user.save_without_session_maintenance
  @user.add_admin_rights
end

Given /^I am an admin with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = Factory.build(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.save_without_session_maintenance
  @user.add_admin_rights
end

Given /^I have logged in$/ do
  visit login_path
  fill_in("Sähköposti", :with => @user.email)
  fill_in("Salasana", :with => @user.password)
  click_button("Kirjaudu")
end
