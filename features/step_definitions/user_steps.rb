Given /^there exists an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  user = build(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official "([^"]*)" "([^"]*)"$/ do |first_name, last_name|
  user = build(:user, :first_name => first_name, :last_name => last_name)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  user = build(:user, :email => email, :password => password)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given /^there is an official "([^"]*)" "([^"]*)" with email "([^"]*)" and password "([^"]*)"$/ do |first_name,
    last_name, email, password|
  user = build(:user, :email => email, :password => password, :first_name => first_name,
    :last_name => last_name)
  user.save_without_session_maintenance
  user.add_official_rights
end

Given(/^"(.*?)" is an official for the race$/) do |email|
  user = User.where(email: email).first
  user.races << @race
end

Given(/^"(.*?)" is the primary official for the race$/) do |email|
  user = User.where(email: email).first
  user.race_rights.create!(race: @race, primary: true)
end

Given /^I am an official$/ do
  @user = build(:user)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)"$/ do |email|
  @user = build(:user, :email => email)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) ([a-zA-Z]*)"$/ do |firstname, lastname|
  @user = build(:user, :first_name => firstname, :last_name => lastname)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)"$/ do |firstname,
    lastname, email|
  @user = build(:user, :first_name => firstname, :last_name => lastname,
    :email => email)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official "(.*) (.*)" with email "([^"]*)" and password "([^"]*)"$/ do |firstname,
    lastname, email, pw|
  @user = build(:user, :first_name => firstname, :last_name => lastname, :email => email, :password => pw)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = build(:user, :email => email, :password => pw)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official with attributes:$/ do |fields|
  @user = build(:user, fields.rows_hash)
  @user.save_without_session_maintenance
  @user.add_official_rights
end

Given /^I am an official for the race "(.*?)"$/ do |race_name|
  @user = build(:user)
  @user.save_without_session_maintenance
  @user.add_official_rights
  @race = create(:race, :name => race_name)
  @user.race_rights << RaceRight.new(:user => @user, :race => @race)
end

Given /^I have only add competitors rights for the race$/ do
  @user.race_rights.create!(:race => @race, :only_add_competitors => true)
end

Given /^I have limited rights to add competitors to the club "(.*?)" in the race$/ do |club_name|
  unless @user
    @user = build(:user)
    @user.save_without_session_maintenance
    @user.add_official_rights
  end
  @user.race_rights.create!(:race => @race, :only_add_competitors => true,
    :club => Club.find_by_name(club_name))
end

Given /^I have limited rights to add competitors for any new club in the race$/ do
  unless @user
    @user = build(:user)
    @user.save_without_session_maintenance
    @user.add_official_rights
  end
  @user.race_rights.create! race: @race, only_add_competitors: true, new_clubs: true
end

Given /^I am an admin$/ do
  @user = build(:user)
  @user.save_without_session_maintenance
  @user.add_admin_rights
end

Given /^I am an admin with email "([^"]*)" and password "([^"]*)"$/ do |email, pw|
  @user = build(:user, :email => email, :password => pw)
  @user.save_without_session_maintenance
  @user.add_admin_rights
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
