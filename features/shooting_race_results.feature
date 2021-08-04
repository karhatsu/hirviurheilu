Feature: Shooting race results
  In order to see how I did
  As a competitor in a race with only shooting
  I want to see the race results

  @javascript
  Scenario: No competitors added for the series
    Given there is a "ILMAHIRVI" race "My race"
    And the race has series "No competitors series"
    When I go to the results page of the series
    Then the "Tulokset" sub menu item should be selected
    And I should see "No competitors series - Ei kilpailijoita" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Tilanne" within "h2"
    And I should see "Sarjaan ei ole lisätty kilpailijoita" in an info message

  @javascript
  Scenario: Show results for race with one phase in qualification and final rounds
    Given there is a "ILMAHIRVI" race "My race"
    And the race has series "M"
    And the series has a competitor 1 "Antti" "Ampuja" from "Antin seura" with shots "10,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,7,9,9"
    And the series has a competitor 2 "Kimmo" "Kilpailija" from "Kimmon seura" with shots "10,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,6,10,9"
    When I go to the results page of the series
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 with 1, "Kilpailija Kimmo", "Kimmon seura" with points 160
    And I should see "75 + 85" in result card 1 detail row 2
    And I should see a card 2 with 2, "Ampuja Antti", "Antin seura" with points 160
    And I should see "75 + 85" in result card 2 detail row 2
    When I show the shots
    Then I should see "75 (10, 9, 8, 10, 9, 5, 6, 7, 3, 8) + 85 (4, 9, 10, 10, 10, 9, 8, 6, 10, 9)" in result card 1 detail row 2
    And I should see "75 (10, 9, 8, 10, 9, 5, 6, 7, 3, 8) + 85 (4, 9, 10, 10, 10, 9, 8, 7, 9, 9)" in result card 2 detail row 2

  @javascript
  Scenario: Show results for race with two phases in qualification round and one in final round
    Given there is a "ILMALUODIKKO" race "My race"
    And the race has series "M"
    And the series has a competitor 1 "Antti" "Ampuja" from "Antin seura" with shots "10,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,7,9,9"
    And the series has a competitor 2 "Kimmo" "Kilpailija" from "Kimmon seura" with shots "9,9,8,10,9,5,6,7,3,8,4,9,10,10,10,9,8,7,10,9"
    And the series has a competitor 3 "Lasse" "Laukoja" from "Lassen seura" with shots "9,9,8"
    And the series has a competitor 4 "Timo" "Tähtääjä" from "Timon seura" with shots "10,10,10,10,10,10,10,10,10,10,10"
    When I go to the results page of the series
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 with 1, "Kilpailija Kimmo", "Kimmon seura" with points 160
    And I should see "45 + 29 = 74" in result card 1 detail row 2
    And I should see "86" in result card 1 detail row 3
    And I should see a card 2 with 2, "Ampuja Antti", "Antin seura" with points 160
    And I should see "46 + 29 = 75" in result card 2 detail row 2
    And I should see "85" in result card 2 detail row 3
    And I should see a card 3 with 3, "Tähtääjä Timo", "Timon seura" with points 110
    And I should see "50 + 50 = 100" in result card 3 detail row 2
    And I should see "10" in result card 3 detail row 3
    And I should see a card 4 with 4, "Laukoja Lasse", "Lassen seura" with points 26
    And I should see "26" in result card 4 detail row 2
    When I show the shots
    Then I should see "45 (9, 9, 8, 10, 9) + 29 (5, 6, 7, 3, 8) = 74" in result card 1 detail row 2
    And I should see "86 (4, 9, 10, 10, 10, 9, 8, 7, 10, 9)" in result card 1 detail row 3
    And I should see "46 (10, 9, 8, 10, 9) + 29 (5, 6, 7, 3, 8) = 75" in result card 2 detail row 2
    And I should see "85 (4, 9, 10, 10, 10, 9, 8, 7, 9, 9)" in result card 2 detail row 3
    And I should see "50 (10, 10, 10, 10, 10) + 50 (10, 10, 10, 10, 10) = 100" in result card 3 detail row 2
    And I should see "10 (10)" in result card 3 detail row 3
    And I should see "26 (9, 9, 8)" in result card 4 detail row 2

  @javascript
  Scenario: Show results for shotgun race
    Given there is a "METSASTYSHAULIKKO" race "Metsästyshaulikko test race"
    And the race has series "N"
    And the series has a competitor 1 "Anna" "Ampuja" from "Annan seura" with shots "1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0"
    And the series has a competitor 2 "Kaija" "Kilpailija" from "Kaijan seura" with shots "1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0"
    And I am on the race page of "Metsästyshaulikko test race"
    When I follow "N"
    And I wait for the results
    And I force mobile UI
    And I show the shots
    Then I should see a card 1 with 1, "Kilpailija Kaija", "Kaijan seura" with points 22
    And I should see "22 (1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0)" in result card 1 detail row 2
    And I should see a card 2 with 2, "Ampuja Anna", "Annan seura" with points 22
    And I should see "22 (1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0)" in result card 2 detail row 2
