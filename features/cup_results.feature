Feature: Cup results
  In order to know what was my total position in a cup competition
  As a competitor
  I want to see the cup results
  
  Scenario: Show main page for cup results
    Given there is a cup "Test cup" with 2 top competitions
    And there is a race "Cup race 1"
    And the race has series "Men"
    And the race has series "Women"
    And the race has series "Special series"
    And the race belongs to the cup
    And there is a race "Another cup race"
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
    
