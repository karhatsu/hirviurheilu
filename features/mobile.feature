Feature: Mobile usage
  As a mobile phone user
  I want that the page UI fits nicely to my mobile devise screen
  So that it is easy to use the pages

  Scenario: Force mobile option
    Given I am on the home page
    And I follow "Mobiilinäkymä"
    Then I should be on the home page
    And I should see "Tulevat kilpailut"
    But I should not see "Kilpailun järjestäjille"
    When I follow "Normaalinäkymä"
    Then I should be on the home page
    And I should see "Tulevat kilpailut"
    And I should see "Kilpailun järjestäjille"
