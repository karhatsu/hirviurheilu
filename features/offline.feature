Feature: Offline usage
  In order to use the system as smoothly as possible
  As a customer without internet connection
  I want to exclude from offline usage such irrelevant features that are relevant in online usage

  Scenario: No pricing information
    Given I use the software offline
    When I am on the home page
    Then I should not see "Hinnat"
    When I follow "Info"
    Then I should not see "Hinnoittelu"

  Scenario: No registration, automatic official login
    Given I use the software offline
    When I am on the home page
    Then I should not see "Kirjaudu sisään"
    And I should not see "Kirjaudu ulos"
    And I should not see "Unohtunut salasana"
    And I should not see "Aloita"
    And I should not see "Omat tiedot"
    When I follow "Toimitsijan sivut"
    Then I should be on the official index page
    When I go to the account page
    Then I should be on the official index page
