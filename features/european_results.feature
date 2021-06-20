Feature: European results
  In order to see how I did in a european race
  As a competitor
  I want to see the european race results

  @javascript
  Scenario: Show european race results
    Given there is a "EUROPEAN" race "European test race"
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" from "Team A" with european results 25, 20, 49, 50, 40, 38
    And the series has a competitor "Pertti" "Pohjonen" from "Team B" with european results 24, 22, 42, 44, 49, 50
    And the race has series "N"
    And the series has a competitor "Päivi" "Pohjoinen" from "Team A" with european results 23, 25, 48, 46, 41, 44
    And the series has a competitor "Pinja" "Pohja" from "Team B" with european results 20, 19, 40, 40, 40, 40
    And the race has a team competition "Teams" with 2 competitors / team
    And I am on the race page of "European test race"
    And the team competition contains the series "M"
    And the team competition contains the series "N"
    When I follow "Tulokset"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 369
    And I should see the following sub results in result card 1 detail row 2:
      | shoot | Trap: 24 |
      | shoot | Compak: 22 |
      | shoot | Metsäkauris: 42 |
      | shoot | Kettu: 44 |
      | shoot | Gemssi: 49 |
      | shoot | Villisika: 50 |
    And I should see a card 2 for "Pohjola Pekka" with total score 357
    And I should see the following sub results in result card 2 detail row 2:
      | shoot | Trap: 25 |
      | shoot | Compak: 20 |
      | shoot | Metsäkauris: 49 |
      | shoot | Kettu: 50 |
      | shoot | Gemssi: 40 |
      | shoot | Villisika: 38 |
    When I follow "Luodikko"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 185
    And I should see the following sub results in result card 1 detail row 2:
      | shoot | Metsäkauris: 42 |
      | shoot | Kettu: 44 |
      | shoot | Gemssi: 49 |
      | shoot | Villisika: 50 |
    And I should see the following sub results in result card 2 detail row 2:
      | shoot | Metsäkauris: 49 |
      | shoot | Kettu: 50 |
      | shoot | Gemssi: 40 |
      | shoot | Villisika: 38 |
    And I should see a card 2 for "Pohjola Pekka" with total score 177
    When I choose "Kilpailun etusivu" from sub menu
    And I follow "Luodikko N"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 179
    When I choose "Joukkuekilpailu" from sub menu
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Team A" with total score 728
    Then I should see a card 2 for "Team B" with total score 685
    When I choose "Luodikon joukkue" from sub menu
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Team A" with total score 356
    Then I should see a card 2 for "Team B" with total score 345
