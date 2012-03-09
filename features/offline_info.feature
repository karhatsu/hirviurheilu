Feature: Offline info
  In order to understand better what Hirviurheilu Offline product is
  As a potential customer for Hirviurheilu
  I want to get more information about Hirviurheilu Offline

  Scenario: No offline tab for offline users
    Given I use the software offline
    When I go to the home page
    Then I should not see "Offline" within "div.main_menu"
    
  Scenario: Default offline path
    Given I go to the offline page
    Then I should be on the offline-online comparison page

  Scenario: Show online vs. offline comparison
    Given I am on the home page
    When I follow "Offline" within "div.main_menu"
    Then I should be on the offline-online comparison page
    And the "Offline" main menu item should be selected
    And the "Online vai Offline?" sub menu item should be selected
    And I should see "Hirviurheilu Online vai Hirviurheilu Offline?" within "div.main_title"

  Scenario: Offline installation instructions
    Given I am an official with email "test@test.com" and password "test"
    And I am on the offline-online comparison page
    When I follow "Katso Hirviurheilu Offline -tuotteen asennusohjeet."
    Then I should be on the offline installation page
    And the "Offline" main menu item should be selected
    And the "Offline-asennus" sub menu item should be selected
    And I should see "Hirviurheilu Offline -tuotteen asennusohjeet" within "div.main_title"
    And I should see /Kun olet kirjautunut palveluun, tähän ilmestyy latauslinkki./ within "div.info"
    But I should not see "Lataa asennustiedosto:"
    When I follow "kirjaudu sisään palveluun"
    And I fill in "test@test.com" for "Sähköposti"
    And I fill in "test" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the offline installation page
    And I should see "Lataa asennustiedosto:"
    But I should not see "Kun olet kirjautunut palveluun, tähän ilmestyy latauslinkki."

  Scenario: Show offline price
    Given I am on the offline installation page
    When I follow "Hinta"
    Then I should be on the offline price page
    And the "Offline" main menu item should be selected
    And the "Hinta" sub menu item should be selected
    And I should see "Hirviurheilu Offline - hinta" within "div.main_title"

  Scenario: No offline download in staging environment
    Given I use the service in the staging environment
    And I am on the home page
    When I follow "Offline"
    And I follow "Offline-asennus"
    Then I should see "Hirviurheilu Offline -asennusohjeet ovat nähtävillä vain varsinaisessa Hirviurheilu Online -palvelussa." within "div.error"
    But I should not see "Kun olet kirjautunut palveluun, tähän ilmestyy latauslinkki."
    Given I am an official
    And I have logged in
    And I am on the offline installation page
    Then I should not see "Lataa asennustiedosto:"

  Scenario: Show offline version history
    Given I am on the offline-online comparison page
    When I follow "Versiohistoria" within "div.sub_menu"
    Then I should be on the offline version history page
    And the "Offline" main menu item should be selected
    And the "Versiohistoria" sub menu item should be selected
    And I should see "Hirviurheilu Offline versiohistoria" within "div.main_title"
    And I should see "1.1.1 - 1.3.2012" within "h2"
    When I follow "Offline-asennus-sivulta"
    Then I should be on the offline installation page
