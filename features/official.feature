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
    When I follow "Toimitsijan etusivu"
    Then I should be on the official index page

  Scenario: Official goes to the official index
    Given I am an official with email "test@test.com" and password "test"
    And I am on the home page
    When I follow "Toimitsijan etusivu"
    Then I should be on the login page
    When I fill in "test@test.com" for "Sähköposti"
    And I fill in "test" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the official index page
    And I should see "Sinulla ei ole vielä yhtään kilpailua. Aloita luomalla kilpailu alla olevasta linkistä." within "div.notice"
