Feature: Pricing
  In order to see how much the service costs
  As a (potential) customer
  I want to see the prices of the service

  Scenario: Show prices
    Given I am on the home page
    When I follow "Info"
    And I follow "Hinnat"
    Then I should be on the prices page
    And the "Info" main menu item should be selected
    And the "Hinnat" sub menu item should be selected
    And the page title should contain "Hinnat"

  Scenario: Do not show prices in staging environment
    Given I use the service in the staging environment
    And I am on the prices page
    Then I should see "Käytät tällä hetkellä testiympäristöä. Sen käyttö on ilmaista."
    And I should see a link to the production environment with text "Tutustu hintoihin varsinaisessa palvelussa"
    But I should not see "ALV"
