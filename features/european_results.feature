Feature: European results
  In order to see how I did in a european race
  As a competitor
  I want to see the european race results

  @javascript
  Scenario: Show european race results for national race
    Given there is a race with attributes:
      | sport_key | EUROPEAN |
      | name      | National test race |
      | show_european_shotgun_results | true |
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" from "Team A" with european results 25, 20, 49, 50, 40, 38
    And the series has a competitor "Pertti" "Pohjonen" from "Team B" with european results 24, 22, 42, 44, 49, 50
    And the competitor has shooting rules penalty of 4
    And the race has series "N"
    And the series has a competitor "Päivi" "Pohjoinen" from "Team A" with european results 23, 25, 48, 46, 41, 44
    And the series has a competitor "Pinja" "Pohja" from "Team B" with european results 20, 19, 40, 40, 40, 40
    And the race has a team competition "Teams" with 2 competitors / team
    And I am on the race page of "National test race"
    And the team competition contains the series "M"
    And the team competition contains the series "N"
    When I follow "Tulokset"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 365
    And I should see the following sub results in result card 1 detail row 2:
      | shoot | Trap: 24 |
      | shoot | Compak: 22 |
      | shoot | Metsäkauris: 42 |
      | shoot | Kettu: 44 |
      | shoot | Gemssi: 49 |
      | shoot | Villisika: 50 |
    And I should see "Rangaistus ammuntasääntöjen rikkomisesta: -4" in result card 1 detail row 3
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
    When I follow "Haulikko"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 184
    And I should see the following sub results in result card 1 detail row 2:
      | shoot | Trap: 24 |
      | shoot | Compak: 22 |
    And I should see the following sub results in result card 2 detail row 2:
      | shoot | Trap: 25 |
      | shoot | Compak: 20 |
    When I choose "Kilpailun etusivu" from sub menu
    And I follow "N" within "#european_rifle_buttons"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 179
    When I choose "Kilpailun etusivu" from sub menu
    And I follow "N" within "#european_shotgun_buttons"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 192
    When I choose "Joukkuekilpailu" from sub menu
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Team A" with total score 728
    Then I should see a card 2 for "Team B" with total score 681
    When I choose "Luodikon joukkue" from sub menu
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Team A" with total score 356
    Then I should see a card 2 for "Team B" with total score 345

  @javascript
  Scenario: Show european race results for international race
    Given there is a race with attributes:
      | sport_key | EUROPEAN |
      | name      | International test race |
      | level     | 4                       |
      | show_european_shotgun_results | true |
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" from "Team A" with european results 25, 20, 49, 50, 40, 38
    And the series has a competitor "Pertti" "Pohjonen" from "Team B" with european results 24, 22, 42, 44, 49, 50
    And the race has series "N"
    And the series has a competitor "Päivi" "Pohjoinen" from "Team A" with european results 23, 25, 48, 46, 41, 44
    And the series has a competitor "Pinja" "Pohja" from "Team B" with european results 20, 19, 40, 40, 40, 40
    And I am on the race page of "International test race"
    When I follow the first "Tulokset" link
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 369
    And I should see a card 2 for "Pohjola Pekka" with total score 357
    When I follow "Luodikko"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 185
    And I should see a card 2 for "Pohjoinen Päivi" with total score 179
    And I should see a card 3 for "Pohjola Pekka" with total score 177
    And I should see a card 4 for "Pohja Pinja" with total score 160
    When I follow "Haulikko"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjoinen Päivi" with total score 192
    And I should see a card 2 for "Pohjonen Pertti" with total score 184
    And I should see a card 3 for "Pohjola Pekka" with total score 180
    And I should see a card 4 for "Pohja Pinja" with total score 156

  @javascript
  Scenario: Show european race results for double race
    Given there is a race with attributes:
      | sport_key | EUROPEAN |
      | name      | Double test race |
      | level     | 4                       |
      | show_european_shotgun_results | true |
    And the race has series "M"
    And the series has a competitor "Pekka" "Pohjola" from "Team A" with european double results 25+25, 20+20, 48+40, 50+50, 50+30, 50+46
    And the series has a competitor "Pertti" "Pohjonen" from "Team B" with european double results 25+23, 25+25, 42+50, 46+44, 50+50, 48+50
    And I am on the race page of "Double test race"
    When I follow the first "Tulokset" link
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 772
    And I should see the following sub results in result card 1 detail row 2:
      | shoot | Trap: 25 + 23 |
      | shoot | Compak: 25 + 25 |
      | shoot | Metsäkauris: 42 + 50 |
      | shoot | Kettu: 46 + 44 |
      | shoot | Gemssi: 50 + 50 |
      | shoot | Villisika: 48 + 50 |
    And I should see a card 2 for "Pohjola Pekka" with total score 724
    When I follow "Luodikko"
    And I wait for the results
    And I force mobile UI
    Then I should see a card 1 for "Pohjonen Pertti" with total score 380
    And I should see a card 2 for "Pohjola Pekka" with total score 364
    When I follow "Haulikko"
    And I wait for the results
    And I force mobile UI
    And I should see a card 1 for "Pohjonen Pertti" with total score 392
    And I should see a card 2 for "Pohjola Pekka" with total score 360
