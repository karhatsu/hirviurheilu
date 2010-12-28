Feature: Finish race
  In order to be able to show the correct estimates for the competitors
  As an official
  I want to finish the race

  Scenario: No series defined for the race
    Given I am an official
    And I have an ongoing race "Test race"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "Merkitse kilpailu päättyneeksi"

  Scenario: The race is in the future
    Given I am an official
    And I have a future race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "Merkitse kilpailu päättyneeksi"

  #Scenario: Competitors are missing correct estimates
  #Scenario: Competitors are missing results
  #Scenario: Finishing race succeeds
