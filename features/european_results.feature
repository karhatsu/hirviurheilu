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
    And I should see "Trap: 24Compak: 22Metsäkauris: 42Kettu: 44Gemssi: 49Villisika: 50" in result card 1 detail row 2
    And I should see a card 2 for "Pohjola Pekka" with total score 357
    And I should see "Trap: 25Compak: 20Metsäkauris: 49Kettu: 50Gemssi: 40Villisika: 38" in result card 2 detail row 2
    When I follow "Luodikko"
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 185
    And I should see "Metsäkauris: 42 Kettu: 44 Gemssi: 49 Villisika: 50" in result card 1 detail row 2
    And I should see "Metsäkauris: 49 Kettu: 50 Gemssi: 40 Villisika: 38" in result card 2 detail row 2
    And I should see a card 2 for "Pohjola Pekka" with total score 177
    When I choose "Kilpailun etusivu" from sub menu
    And I follow "Luodikko N"
    And I force mobile UI
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 179
    When I choose "Joukkuekilpailu" from sub menu
    And I force mobile UI
    Then I should see a card 1 for "Team A" with total score 728
    Then I should see a card 2 for "Team B" with total score 685
    When I choose "Luodikon joukkue" from sub menu
    And I force mobile UI
    Then I should see a card 1 for "Team A" with total score 356
    Then I should see a card 2 for "Team B" with total score 345
