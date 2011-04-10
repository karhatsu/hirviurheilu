Feature: Admin
  In order to manage general data in the system
  As an administrator
  I want to access the admin pages

  Scenario: Unauthenticated user cannot get to the admin pages
    Given I go to the admin index page
    Then I should be on the login page

  Scenario: Official cannot get to the admin pages
    Given I am an official with email "test@test.com" and password "test"
    And I have logged in
    When I go to the admin index page
    Then I should be on the home page

  Scenario: Admin goes to the official index
    Given I am an admin with email "test@test.com" and password "test"
    And I am on the home page
    When I go to the admin index page
    Then I should be on the login page
    When I fill in "test@test.com" for "Sähköposti"
    And I fill in "test" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the admin index page
    And the "Admin" main menu item should be selected
