Feature: European results
  In order to see how I did in a european race
  As a competitor
  I want to see the european race results

  Scenario: Show european race results
    Given there is a "EUROPEAN" race "European test race"
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" with european results 25, 20, 49, 50, 40, 38
    And the series has a competitor "Pertti" "Pohjonen" with european results 24, 22, 42, 44, 49, 50
    And the race has series "N"
    And the series has a competitor "Päivi" "Pohjoinen" with european results 23, 25, 48, 46, 41, 44
    And I am on the race page of "European test race"
    When I follow "Tulokset"
    Then I should see a card 1 for "Pohjonen Pertti" with total score 369
    And I should see "Trap: 24 Compak: 22 Metsäkauris: 42 Kettu: 44 Gemssi: 49 Villisika: 50" in result card 1 detail row 2
    And I should see a card 2 for "Pohjola Pekka" with total score 357
    And I should see "Trap: 25 Compak: 20 Metsäkauris: 49 Kettu: 50 Gemssi: 40 Villisika: 38" in result card 2 detail row 2
    When I follow "Luodikko"
    Then I should see a card 1 for "Pohjonen Pertti" with total score 185
    And I should see "Metsäkauris: 42 Kettu: 44 Gemssi: 49 Villisika: 50" in result card 1 detail row 2
    And I should see "Metsäkauris: 49 Kettu: 50 Gemssi: 40 Villisika: 38" in result card 2 detail row 2
    And I should see a card 2 for "Pohjola Pekka" with total score 177
    When I choose "Kilpailun etusivu" from sub menu
    And I follow "Luodikko N"
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 179
