Feature: Pricing
  In order to see how much the service costs
  As a (potential) customer
  I want to see the prices of the service

  Scenario: Show prices
    Given there is a base price 15
    And there is a price "3" for min competitors 1
    And there is a price "2.50" for min competitors 50
    And there is a price "1" for min competitors 100
    And I am on the home page
    When I follow "Hinnat"
    Then I should be on the prices page
    And the "Hinnat" main menu item should be selected
    And the page title should contain "Hinnat"
    And I should see "Perushinta"
    And I should see "15.00 euroa"
    And I should see "1-49 kilpailijaa"
    And I should see "3.00 euroa / kilpailija"
    And I should see "50-99 kilpailijaa"
    And I should see "2.50 euroa / kilpailija"
    And I should see "100- kilpailijaa"
    And I should see "1.00 euro / kilpailija"
    And I should see "Kaikki hinnat sisältävät 24 % arvonlisäveroa."

  Scenario: Do not show prices in staging environment
    Given there is a base price 5
    And there is a price "2" for min competitors 1
    And I use the service in the staging environment
    And I am on the prices page
    Then I should see "Käytät tällä hetkellä testiympäristöä. Sen käyttö on ilmaista."
    But I should not see "Perushinta"
    And I should not see "1- kilpailijaa"
    And I should not see "Hintalaskuri"
    And I should not see "Hirviurheilu Offline"
    But I should see a link to the production environment with text "Tutustu hintoihin varsinaisessa palvelussa"
    