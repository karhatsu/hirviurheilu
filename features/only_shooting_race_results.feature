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
    And the series has a competitor 1 "Antti" "Ampuja" from "Antin seura" with shots "10,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,7,9,9"
    And the series has a competitor 2 "Kimmo" "Kilpailija" from "Kimmon seura" with shots "10,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,6,10,9"
    When I go to the results page of the series
    Then I should see a card 1 with 1, "Kilpailija Kimmo", "Kimmon seura" with points 160
    And I should see "Alkukilpailu: 75 (10, 9, 8, 10, 9, 5, 6, 7, 3, 8)" in result card 1 detail row 2
    And I should see "Loppukilpailu: 85 (4, 9, 10, 10, 10, 9, 8, 6, 10, 9)" in result card 1 detail row 3
    Then I should see a card 2 with 2, "Ampuja Antti", "Antin seura" with points 160
    And I should see "Alkukilpailu: 75 (10, 9, 8, 10, 9, 5, 6, 7, 3, 8)" in result card 2 detail row 2
    And I should see "Loppukilpailu: 85 (4, 9, 10, 10, 10, 9, 8, 7, 9, 9)" in result card 2 detail row 3
