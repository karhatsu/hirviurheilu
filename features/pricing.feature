Feature: Pricing
  In order to see how much the service costs
  As a (potential) customer
  I want to see the prices of the service

  @javascript
  Scenario: Show prices
    Given I am on the home page
    When I follow "Info"
    And I follow "Hinnat"
    Then I should be on the prices page
    And the "Info" main menu item should be selected
    And the "Hinnat" sub menu item should be selected
    And the page title should contain "Hinnat"
