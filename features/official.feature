Feature: Official
  In order to manage races
  As a race official
  I want to access the official pages

  Scenario: Unauthenticated user cannot get to the official pages
    Given I go to the official index page
    Then I should be on the login page
