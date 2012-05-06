Feature: Cup results
  In order to know what was my total position in a cup competition
  As a competitor
  I want to see the cup results
  
  Scenario: Show main page for cup results
    Given there is a cup "Test cup" with 2 top competitions
    And the cup has a series "Men"
    And the cup has a series "Women"
    And there is a race with attributes:
      | name | Cup race 1 |
      | start_date | 2012-03-20 |
      | location | Test ski city |
    And the race has series "Men"
    And the race has series "Women"
    And the race has series "Special series"
    And the race belongs to the cup
    And there is a race with attributes:
      | name | Another cup race |
      | start_date | 2012-04-01 |
      | end_date | 2012-04-02 |
      | location | Skiing town |
    And the race has series "Men"
    And the race has series "Women"
    And the race belongs to the cup
    And there is a race "Non-cup race"
    When I go to the cup page
    Then the "Kilpailut" main menu item should be selected
    And the "Cup-kilpailun etusivu" sub menu item should be selected
    And I should see "Test cup" within ".main_title"
    And I should see "Osakilpailut" within "h2"
    And I should see "Cup race 1"
    And I should see "Another cup race"
    But I should not see "Non-cup race"
    And I should see "Sarjat"
    And I should see "Men"
    And I should see "Women"
    But I should not see "Special series"
    When I follow "Another cup race"
    Then I should be on the race page of "Another cup race"
    
  Scenario: Show results for a cup series
    Given there is a cup "Test cup" with 2 top competitions
    And the cup has a series "Men"
    And there is a race "Cup race 1"
    And the race has series with attributes:
      | name | Men |
      | start_time | 10:00 |
      | first_number | 1 |
      | has_start_list | true |
    And the series has a competitor "Antti" "Miettinen" with 300+300+594 points
    And the series has a competitor "Timo" "Turunen" with 300+298+600 points
    And the race belongs to the cup
    And there is a race "Another cup race"
    And the race has series with attributes:
      | name | Men |
      | start_time | 10:00 |
      | first_number | 1 |
      | has_start_list | true |
    And the series has a competitor "Timo" "Turunen" with 300+296+600 points
    And the series has a competitor "Antti" "Miettinen" with 300+300+588 points
    And the race belongs to the cup
    And there is a race "Third race for cup"
    And the race has series with attributes:
      | name | Men |
      | start_time | 10:00 |
      | first_number | 1 |
      | has_start_list | true |
    And the series has a competitor "Timo" "Turunen" with 300+300+600 points
    And the series has a competitor "Antti" "Miettinen" with 300+290+600 points
    And the race belongs to the cup
    When I go to the cup page
    And I follow "Men"
    Then the "Kilpailut" main menu item should be selected
    And the "Tulokset" sub menu item should be selected
    And I should see "Tulokset - Men" within "h2"
    And I should see "Cup race 1" within "thead"
    And I should see "Another" within "thead"
    And I should see "Third " within "thead"
    And I should see "Turunen Timo"
    And I should see "1198" within "tr#comp_1"
    And I should see "1196" within "tr#comp_1"
    And I should see "1200" within "tr#comp_1"
    And I should see "2398" within "tr#comp_1"
    And I should see "Miettinen Antti"
    And I should see "1194" within "tr#comp_2"
    And I should see "1188" within "tr#comp_2"
    And I should see "1190" within "tr#comp_2"
    And I should see "2384" within "tr#comp_2"

  Scenario: Show results for a cup series containing two series
    Given there is a cup "Test cup" with 2 top competitions
    And the cup has a series "Men" with series names "M,M60"
    And there is a race "Cup race 1"
    And the race has series with attributes:
      | name | M |
      | start_time | 10:00 |
      | first_number | 1 |
      | has_start_list | true |
    And the series has a competitor "Antti" "Miettinen" with 300+300+594 points
    And the series has a competitor "Timo" "Turunen" with 300+298+600 points
    And the race has series with attributes:
      | name | M60 |
      | start_time | 11:00 |
      | first_number | 10 |
      | has_start_list | true |
    And the series has a competitor "Markku" "Pöllänen" with 300+300+600 points
    And the race belongs to the cup
    And there is a race "Another cup race"
    And the race has series with attributes:
      | name | M |
      | start_time | 10:00 |
      | first_number | 1 |
      | has_start_list | true |
    And the series has a competitor "Timo" "Turunen" with 300+296+600 points
    And the series has a competitor "Antti" "Miettinen" with 300+300+588 points
    And the race has series with attributes:
      | name | M60 |
      | start_time | 11:00 |
      | first_number | 10 |
      | has_start_list | true |
    And the series has a competitor "Markku" "Pöllänen" with 300+300+600 points
    And the race belongs to the cup
    When I go to the cup page
    And I follow "Men"
    Then the "Kilpailut" main menu item should be selected
    And the "Tulokset" sub menu item should be selected
    And I should see "Tulokset - Men" within "h2"
    And I should see "Cup race 1" within "thead"
    And I should see "Another" within "thead"
    And I should see "Pöllänen Markku"
    And I should see "M60" within "tr#comp_1"
    And I should see "1200" within "tr#comp_1"
    And I should see "1200" within "tr#comp_1"
    And I should see "2400" within "tr#comp_1"
    And I should see "Turunen Timo"
    And I should see "M" within "tr#comp_2"
    And I should see "1198" within "tr#comp_2"
    And I should see "1196" within "tr#comp_2"
    And I should see "2394" within "tr#comp_2"
    And I should see "Miettinen Antti"
    And I should see "M" within "tr#comp_3"
    And I should see "1194" within "tr#comp_3"
    And I should see "1188" within "tr#comp_3"
    And I should see "2382" within "tr#comp_3"
    