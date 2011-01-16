Feature: Official
  In order to manage races
  As a race official
  I want to access the official pages and fill in race information

  Scenario: Unauthenticated user cannot get to the official pages
    Given I go to the official index page
    Then I should be on the login page

  Scenario: Official registration
    Given I go to the registration page
    When I fill in the following:
      | Etunimi | Tim |
      | Sukunimi | Tester |
      | Sähköposti | tim@tester.com |
      | Salasana | testpassword |
      | Salasana uudestaan | testpassword |
    And I press "Rekisteröidy"
    Then I should see "Käyttäjätili luotu."
    When I follow "Toimitsijan sivut"
    Then I should be on the official index page
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - uusi käyttäjä (test)" in the email subject
    And I should see "Etunimi: Tim" in the email body
    And I should see "Sukunimi: Tester" in the email body
    And I should see "Sähköposti: tim@tester.com" in the email body

  Scenario: Official goes to the official index
    Given I am an official with email "test@test.com" and password "test"
    And I am on the home page
    When I follow "Toimitsijan sivut"
    Then I should be on the login page
    When I fill in "test@test.com" for "Sähköposti"
    And I fill in "test" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the official index page
    And I should see "Sinulla ei ole vielä yhtään kilpailua. Aloita luomalla kilpailu alla olevasta linkistä." within "div.instructions"
    But I should not see "Valitse kilpailu"
    But I should not see "Tai"

  Scenario: Official index with races
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And I am on the official index page
    Then I should see "Valitse kilpailu" within "#existing_races h2"
    And I should see "Test race" within "#existing_races"
    And I should see "Tai" within "h2#new_race"
    And I should see "Lisää uusi kilpailu"
