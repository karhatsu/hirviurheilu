Feature: Remove race
  As an official who has created a race with test purposes
  I want to remove the race
  So that I can get rid of useless test data
  
  Scenario: Remove race when it has no competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    When I press "Poista kilpailu"
    Then I should be on the official index page
    And I should see "Kilpailu poistettu" in a success message
    
  Scenario: Cannot remove race when it has competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series "Test series"
    And the series has a competitor
    And I have logged in
    And I am on the official race page of "Test race"
    Then the page should not contain the remove race button
  
  Scenario: Cannot remove race when it has relays
    Given I am an official
    And I have a race "Test race"
    And the race has a relay "Test relay"
    And I have logged in
    And I am on the official race page of "Test race"
    Then the page should not contain the remove race button
  