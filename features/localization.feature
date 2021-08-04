Feature: Localization
  In order to understand the service
  As a Swedish user
  I want to use the system in Swedish

  @javascript
  Scenario: Change language, change page, change the language again
    Given I am on the home page
    And I follow "På svenska"
    Then I should be on the Swedish home page
    When I follow "Sök tävling"
    Then I should see "Hirviurheilu - Tävlingar" within ".body__on-top-title"
    When I follow "Suomeksi"
    Then I should see "Hirviurheilu - Kilpailut" within ".body__on-top-title"
