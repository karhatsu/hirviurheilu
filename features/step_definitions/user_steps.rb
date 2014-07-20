# encoding: UTF-8
Given /^there exists an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  user = FactoryGirl.build(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given(/^there exists an official "(.*) (.*)" with email "(.*?)" and race "(.*?)"$/) do |firstname,
    lastname, email, race_name|
  user = FactoryGirl.build(:user, :first_name => firstname, :last_name => lastname,
                           :email => email)
  user.save_without_session_maintenance
  user.add_official_rights
  race = FactoryGirl.create(:race, name: race_name)
  user.races << race
end

Given /^there is an official "([^"]*)" "([^"]*)"$/ do |first_name, last_name|
  user = FactoryGirl.build(:user, :first_name => first_name, :last_name => last_name)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  user = FactoryGirl.build(:user, :email => email, :password => password,
    :password_confirmation => password)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official "([^"]*)" "([^"]*)" with email "([^"]*)" and password "([^"]*)"$/ do |first_name,
    last_name, email, password|
  user = FactoryGirl.build(:user, :email => email, :password => password,
    :password_confirmation => password, :first_name => first_name,
    :last_name => last_name)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^I am an official$/ do
  @user = FactoryGirl.build(:user)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)"$/ do |email|
  @user = FactoryGirl.build(:user, :email => email)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) ([a-zA-Z]*)"$/ do |firstname, lastname|
  @user = FactoryGirl.build(:user, :first_name => firstname, :last_name => lastname)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  @user = FactoryGirl.build(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)" and password "([^"]*)"$/ do |firstname,
    lastname, email, pw|
  @user = FactoryGirl.build(:user, :first_name => firstname, :last_name => lastname,
    :email => email, :password => pw, :password_confirmation => pw)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = FactoryGirl.build(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with attributes:$/ do |fields|
  @user = FactoryGirl.build(:user, fields.rows_hash)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official for the race "(.*?)"$/ do |race_name|
  @user = FactoryGirl.build(:user)
  @user.save_without_session_maintenance
  @user.add_official_rights
  @race = FactoryGirl.create(:race, :name => race_name)
  @user.race_rights << RaceRight.new(:user => @user, :race => @race)
end

Given /^I have only add competitors rights for the race$/ do
  @user.race_rights.create!(:race => @race, :only_add_competitors => true)
end

Given /^I have limited rights to add competitors to the club "(.*?)" in the race$/ do |club_name|
  unless @user
    @user = FactoryGirl.build(:user)
    @user.save_without_session_maintenance
    @user.add_official_rights
  end
  @user.race_rights.create!(:race => @race, :only_add_competitors => true,
    :club => Club.find_by_name(club_name))
end

Given /^I am an admin$/ do
  @user = FactoryGirl.build(:user)
  @user.save_without_session_maintenance
  @user.add_admin_rights
end

Given /^I am an admin with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = FactoryGirl.build(:user, :email => email, :password => pw, :password_confirmation => pw)
  @user.save_without_session_maintenance
  @user.add_admin_rights
end

Given /^I have already opened the activation key with invoicing info "(.*?)"$/ do |invoicing_info|
  @user.activation_key = 'activation-key'
  @user.invoicing_info = invoicing_info
  @user.save!
end

Given /^I have logged in$/ do
  visit login_path
  fill_in("Sähköposti", :with => @user.email)
  fill_in("Salasana", :with => @user.password)
  click_button("Kirjaudu")
end

Given /^I change my password to "(.*?)"$/ do |new_password|
  steps %Q{
    When I follow "Omat tiedot"
    And I follow "Muokkaa tietoja"
    And I fill in "#{new_password}" for "Vaihda salasana"
    And I fill in "#{new_password}" for "Salasana uudestaan"
    And I press "Päivitä"
  }
end

When /^I logout$/ do
  click_link("Kirjaudu ulos")
end