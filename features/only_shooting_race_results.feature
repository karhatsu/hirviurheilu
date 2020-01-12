Feature: Only shooting race results
  In order to see how I did
  As a competitor in a race with only shooting
  I want to see the race results

  Scenario: No competitors added for the series
    Given there is a "ILMAHIRVI" race "My race"
    And the race has series "No competitors series"
    When I go to the results page of the series
    Then the "Kilpailut" main menu item should be selected
    And the "Tulokset" sub menu item should be selected
    And I should see "No competitors series - (Ei kilpailijoita)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Tilanne" within "h2"
    And I should see "Sarjaan ei ole lisätty kilpailijoita" in an info message

  Scenario: Show results
    Given there is a "ILMAHIRVI" race "My race"
    And the race has series "M"
    And the series has a competitor 1 "Kimmo" "Kilpailija" from "Test club" with shots "10,9,8,10"
    When I go to the results page of the series
    Then I should see a card 1 with 1, "Kilpailija Kimmo", "Test club" with points 37
