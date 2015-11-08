Feature: Ask for an offer
  As a customer
  I want to ask for an offer
  So that I would get cheaper price for my competitions

  Scenario: Send offer form
    Given I use the service in the production environment
    And I am on the home page
    And I follow "Pyydä tarjous"
    Then the "Hinnat" main menu item should be selected
    And the "Pyydä tarjous" sub menu item should be selected
    And the page title should contain "Pyydä tarjous"
    When I fill the ask for an offer form
    Then I should see "Kiitos tarjouspyynnöstä" in a success message
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - tarjouspyyntö" in the email subject
    And the email sender should be the offer sender
    And the email body should contain the offer information

  Scenario: No offer section in staging environment
    Given I use the service in the staging environment
    And I am on the home page
    Then I should not see "Pyydä tarjous"
