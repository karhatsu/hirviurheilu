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

  Scenario: Show results for race with one phase in qualification and final rounds
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

  Scenario: Show results for race with two phases in qualification round and one in final round
    Given there is a "ILMALUODIKKO" race "My race"
    And the race has series "M"
    And the series has a competitor 1 "Antti" "Ampuja" from "Antin seura" with shots "10,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,7,9,9"
    And the series has a competitor 2 "Kimmo" "Kilpailija" from "Kimmon seura" with shots "9,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,7,10,9"
    And the series has a competitor 3 "Lasse" "Laukoja" from "Lassen seura" with shots "9,9,8"
    And the series has a competitor 4 "Timo" "Tähtääjä" from "Timon seura" with shots "10,10,10,10,10,10,10,10,10,10,10"
    When I go to the results page of the series
    Then I should see a card 1 with 1, "Kilpailija Kimmo", "Kimmon seura" with points 160
    And I should see "Alkukilpailu: 45 (9, 9, 8, 10, 9) + 29 (5, 6, 7, 3, 8) = 74" in result card 1 detail row 2
    And I should see "Loppukilpailu: 86 (4, 9, 10, 10, 10, 9, 8, 7, 10, 9)" in result card 1 detail row 3
    Then I should see a card 2 with 2, "Ampuja Antti", "Antin seura" with points 160
    And I should see "Alkukilpailu: 46 (10, 9, 8, 10, 9) + 29 (5, 6, 7, 3, 8) = 75" in result card 2 detail row 2
    And I should see "Loppukilpailu: 85 (4, 9, 10, 10, 10, 9, 8, 7, 9, 9)" in result card 2 detail row 3
    Then I should see a card 3 with 3, "Tähtääjä Timo", "Timon seura" with points 110
    And I should see "Alkukilpailu: 50 (10, 10, 10, 10, 10) + 50 (10, 10, 10, 10, 10) = 100" in result card 3 detail row 2
    And I should see "Loppukilpailu: 10 (10)" in result card 3 detail row 3
    Then I should see a card 4 with 4, "Laukoja Lasse", "Lassen seura" with points 26
    And I should see "Alkukilpailu: 26 (9, 9, 8)" in result card 4 detail row 2
