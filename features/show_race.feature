Feature: Show race
  In order to see race series and other information
  As a user
  I want to see race details

  Scenario: Show race details and series
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 2010-01-01 13:30 |
    When I go to the race page
    Then I should see "My test race" within "h1"
    And I should see "Test city, 01.01.2010 - 02.01.2010"
    And I should see "Men 50 years"
    And I should see "01.01.2010 13:30"
