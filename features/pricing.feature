Feature: Pricing
  In order to see how much the service costs
  As a (potential) customer
  I want to see the prices of the service

  Scenario: Show prices
    Given I am on the home page
    When I follow "Hinnat"
    Then I should be on the prices page
    And the "Hinnat" main menu item should be selected
    And the page title should contain "Hinnat"
    And I should see "1,00 euro / kilpailija"
    And I should see "sis. ALV 24%"

  Scenario: Do not show prices in staging environment
    Given I use the service in the staging environment
    And I am on the prices page
    Then I should see "Käytät tällä hetkellä testiympäristöä. Sen käyttö on ilmaista."
    And I should see a link to the production environment with text "Tutustu hintoihin varsinaisessa palvelussa"
    But I should not see "ALV"
