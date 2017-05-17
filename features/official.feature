Feature: Official
  In order to manage races
  As a race official
  I want to access the official pages and fill in race information

  Scenario: Unauthenticated user cannot get to the official pages
    Given I go to the official index page
    Then I should be on the login page

  Scenario: Official registration
    Given I am on the home page
    When I choose "Aloita käyttö" from main menu
    Then I should be on the registration page
    And the "Aloita" main menu item should be selected
    When I fill in the following:
      | Etunimi | Tim |
      | Sukunimi | Tester |
      | Seura | Club |
      | Sähköposti | tim@tester.com |
      | Salasana | testpassword |
      | Salasana uudestaan | testpassword |
    And I press "Rekisteröidy"
    Then I should see "Käyttäjätili luotu."
    When I follow "Toimitsijan sivut"
    Then I should be on the official index page
    And the official main menu item should be selected
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - uusi käyttäjä (test)" in the email subject
    And I should see "Etunimi: Tim" in the email body
    And I should see "Sukunimi: Tester" in the email body
    And I should see "Sähköposti: tim@tester.com" in the email body

  Scenario: Previously registered official goes to the registration page
    Given I am on the registration page
    When I follow "Kirjaudu sisään" within ".main_content"
    Then I should be on the login page

  Scenario: Official goes to the official index
    Given I am an official with email "test@test.com" and password "test1234"
    And I am on the home page
    When I follow "Toimitsijan sivut"
    Then I should be on the login page
    When I fill in "test@test.com" for "Sähköposti"
    And I fill in "test1234" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the official index page
    And I should see "Sinulla ei ole vielä yhtään kilpailua. Aloita luomalla kilpailu alla olevasta linkistä." in an info message
    But I should not see "Valitse kilpailu"
    But I should not see "Tai"

  Scenario: Official index with races
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And I am on the official index page
    Then I should see "Kilpailut" within "#existing_races h2"
    And I should see "Test race" within "#existing_races"
    And I should see "Lisää uusi kilpailu"
    And I should see "Lisää uusi cup-kilpailu"

  Scenario: Official index with cups and cup races
    Given I am an official
    And I have a cup "Test cup"
    And I have a race "Test race"
    And the race belongs to the cup
    And I have logged in
    And I am on the official index page
    Then I should see "Test cup"
    And I should see "Test race"

  Scenario: Official cannot access someone else's races in official pages
    Given there is a race "Test race"
    And I am an official
    And I have logged in
    When I go to the official race page of "Test race"
    Then I should be on the official index page
    And I should see "Et ole kilpailun toimitsija" in an error message
    