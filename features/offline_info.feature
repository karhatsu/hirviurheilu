Feature: Offline info
  In order to understand better what Hirviurheilu Offline product is
  As a potential customer for Hirviurheilu
  I want to get more information about Hirviurheilu Offline

  Scenario: No offline tab for offline users
    Given I use the software offline
    When I go to the home page
    Then I should not see "Offline" within "div.main_menu"

  Scenario: No offline tab in staging environment
    Given I use the service in the staging environment
    When I go to the home page
    Then I should not see "Offline" within "div.main_menu"
    When I go to the offline-online comparison page
    Then I should be on the home page
    When I go to the offline installation page
    Then I should be on the home page
    When I go to the offline price page
    Then I should be on the home page

  Scenario: Show online vs. offline comparison
    Given I am on the home page
    When I follow "Offline" within "div.main_menu"
    Then I should be on the offline-online comparison page
    And the "Offline" main menu item should be selected
    And the "Online vai Offline?" sub menu item should be selected
    And I should see "Hirviurheilu Online vai Hirviurheilu Offline?" within "div.main_title"

  Scenario: Offline installation instructions
    Given I am on the offline-online comparison page
    When I follow "Katso Hirviurheilu Offline -tuotteen asennusohjeet."
    Then I should be on the offline installation page
    And the "Offline" main menu item should be selected
    And the "Offline-asennus" sub menu item should be selected
    And I should see "Hirviurheilu Offline -tuotteen asennusohjeet" within "div.main_title"

  Scenario: Show offline price
    Given I am on the offline installation page
    When I follow "Hinta"
    Then I should be on the offline price page
    And the "Offline" main menu item should be selected
    And the "Hinta" sub menu item should be selected
    And I should see "Hirviurheilu Offline - hinta" within "div.main_title"
