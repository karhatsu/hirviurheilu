Feature: Copy competitors
  In order to save time when creating a new repeating competition
  As an official
  I want to copy competitors from another race of mine

  Scenario: Copy competitors
    Given I am an official
    And I have a race "Source race"
    And the race has series "Men"
    And the series has an age group "M50"
    And the series has a competitor "Simon" "Source"
    And the competitor belongs to an age group "M50"
    And the race has series "Women"
    And the series has a competitor "Shelly" "Sourcé"
    And I have a race "Target race"
    And the race has series "Women"
    And I have a race "Yet another race"
    When I have logged in
    And I am on the official race page of "Target race"
    And I follow "Kopioi kilpailijat toisesta kilpailusta"
    And I select "Source race" from "Kilpailu josta kilpailijat kopioidaan"
    And I press "Kopioi kilpailijat"
    Then I should be on the official race page of "Target race"
    And I should see "Kilpailijat (2) kopioitu" in a success message
    When I follow the first "1 hlö" link
    Then I should see "Source Simon (M50)"
