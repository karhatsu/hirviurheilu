Feature: Nordic results
  In order to see how I did in a nordic race
  As a competitor
  I want to see the nordic race results

  @javascript
  Scenario: Show nordic race results
    Given there is a "NORDIC" race "Nordic test race"
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" from "Team A" with nordic results 24, 20, 99, 100
    And the competitor has shooting rules penalty of 2
    And the series has a competitor "Pertti" "Pohjonen" from "Team B" with nordic results 25, 21, 90, 92
    And the race has series "N"
    And the series has a competitor "Päivi" "Pohjoinen" from "Team B" with nordic results 21, 25, 100, 96
    And the series has a competitor "Pinja" "Pohja" from "Team A" with nordic results 20, 19, 89, 91
    And the race has a team competition "Nordic teams" with 2 competitors / team
    And the team competition contains the series "M"
    And the team competition contains the series "N"
    And I am on the race page of "Nordic test race"
    When I follow "Tulokset"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjola Pekka" with total score 373
    And I should see the following sub results in result card 1 detail row 2:
      | shoot | Trap: 24 |
      | shoot | Compak: 20 |
      | shoot | Hirvi: 99 |
      | shoot | Kauris: 100 |
    And I should see "Rangaistus ammuntasääntöjen rikkomisesta: -2" in result card 1 detail row 3
    And I should see a card 2 for "Pohjonen Pertti" with total score 366
    And I should see the following sub results in result card 2 detail row 2:
      | shoot | Trap: 25 |
      | shoot | Compak: 21 |
      | shoot | Hirvi: 90 |
      | shoot | Kauris: 92 |
    When I follow "Trap"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 25
    And I should see a card 2 for "Pohjola Pekka" with total score 24
    And I should see a card 3 for "Pohjoinen Päivi" with total score 21
    When I choose "Compak" from sub menu
    And I wait for the results
    And I force mobile UI
    And I should see a card 1 for "Pohjoinen Päivi" with total score 25
    Then I should see a card 2 for "Pohjonen Pertti" with total score 21
    And I should see a card 3 for "Pohjola Pekka" with total score 20
    When I choose "Hirvi" from sub menu
    And I wait for the results
    And I force mobile UI
    And I should see a card 1 for "Pohjoinen Päivi" with total score 100
    Then I should see a card 2 for "Pohjola Pekka" with total score 99
    And I should see a card 3 for "Pohjonen Pertti" with total score 90
    When I choose "Kauris" from sub menu
    And I wait for the results
    And I force mobile UI
    And I should see a card 1 for "Pohjola Pekka" with total score 100
    Then I should see a card 2 for "Pohjoinen Päivi" with total score 96
    And I should see a card 3 for "Pohjonen Pertti" with total score 92
    When I choose "Joukkuekilpailu" from sub menu
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Team B" with total score 746
    Then I should see a card 2 for "Team A" with total score 709

  @javascript
  Scenario: Show nordic race sub sport results for series
    Given there is a nordic race "Nordic test race" with series level sub sport results
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" from "Team A" with nordic results 24, 20, 99, 100
    And the series has a competitor "Pertti" "Pohjonen" from "Team B" with nordic results 25, 21, 90, 92
    And the race has series "N"
    And the series has a competitor "Päivi" "Pohjoinen" from "Team B" with nordic results 21, 25, 100, 96
    And the series has a competitor "Pinja" "Pohja" from "Team A" with nordic results 20, 19, 89, 91
    And I am on the race page of "Nordic test race"
    When I follow "Trap"
    Then I should see "M - Trap" within "h2"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 25
    And I should see a card 2 for "Pohjola Pekka" with total score 24
    When I follow "N" within ".menu--sub-1"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 21
    And I should see a card 2 for "Pohja Pinja" with total score 20
