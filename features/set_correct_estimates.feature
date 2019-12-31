Feature: Set correct estimates
  So that distance estimate points can be calculated
  As an official
  I want to set correct estimates

  Scenario: No competitors
    Given I am an official for the race "Test race"
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow the first "Oikeat etäisyydet" link
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Oikeat etäisyydet" sub menu item should be selected
    And I should see "Et ole lisännyt kilpailuun vielä yhtään kilpailijaa." in an info message
    But I should not see "Etäisyys 1"

  @javascript
  Scenario: Set correct estimates with two ranges
    Given I am an official for the race "Test race"
    And the race has a series "Test series" with first number 1 and start time "00:00:00"
    And the series has a competitor "Filip" "First"
    And the series has a competitor "Simon" "Second"
    And the series has a competitor "Tim" "Third"
    And the series has a competitor "Foo" "Fourth"
    And the start list has been generated for the series
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow the first "Oikeat etäisyydet" link
    And I fill correct estimate 100 and 150 for the range 1-2 in row 1
    And I press "Lisää uusi lähtönumeroväli"
    And I fill correct estimate 120 and 80 for the range 3- in row 2
    And I press "Tallenna oikeat etäisyydet ja aseta ne kilpailijoille"
    Then I should see correct estimates 100 and 150 set for the competitor "Filip" "First" with number 1
    And I should see correct estimates 100 and 150 set for the competitor "Simon" "Second" with number 2
    And I should see correct estimates 120 and 80 set for the competitor "Tim" "Third" with number 3
    And I should see correct estimates 120 and 80 set for the competitor "Foo" "Fourth" with number 4
