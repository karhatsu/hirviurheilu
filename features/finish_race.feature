Feature: Finish race
  In order to be able to show the correct estimates for the competitors
  As an official
  I want to finish the race

  Scenario: No series defined for the race
    Given I am an official
    And I have an ongoing race "Test race"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "kun kaikki tulokset on syötetty"

  Scenario: The race is in the future
    Given I am an official
    And I have a future race "Test race"
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "kun kaikki tulokset on syötetty"

  Scenario: Competitors are missing correct estimates
    Given I am an official
    And I have an ongoing race "Test race"
    And the race has series "Test series"
    And the series has a competitor
    And I have logged in
    When I go to the official race page of "Test race"
    Then I should see "kun kaikki tulokset on syötetty, jotta oikeat arviomatkat voidaan julkaista." within "form"
    When I press "Merkitse kilpailu päättyneeksi"
    Then I should see "Osalta kilpailijoista puuttuu oikea arviomatka." within "div.error_explanation"
    When I go to the official race page of "Test race"
    Then I should see "kun kaikki tulokset on syötetty, jotta oikeat arviomatkat voidaan julkaista." within "form"

  #Scenario: Competitors are missing results
  #Scenario: Finishing race succeeds
