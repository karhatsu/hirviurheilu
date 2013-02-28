Feature: Start list
  In order to know when I need to start
  As a competitor
  I want to see the series start list

  Scenario: Go to see the start list
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 30 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
    And the race has a club "Shooting club"
    And the race has a club "Sports club"
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
      | club | Sports club |
    And the start list has been generated for the series
    And I am on the race page
    When I follow "Lähtölista"
    Then I should be on the start list page of the series
    And the "Kilpailut" main menu item should be selected
    And the "Lähtölistat" sub menu item should be selected
    And the page title should contain "My test race"
    And I should see "Men 50 years - Lähtölista" within "h2"
    And I should see a start list row 1 with values:
      | number | 50 |
      | name | Johnson James |
      | club | Shooting club |
      | time | 13:00:00 |
    And I should see a start list row 2 with values:
      | number | 51 |
      | name | Atkinsson Tim |
      | club | Sports club |
      | time | 13:00:30 |
    But I should not see "Jotosjoukkue"
    
  Scenario: Start list for competitors having team name
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
    And the race has a club "Shooting club"
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
      | team_name | Special team |
    And the start list has been generated for the series
    And I am on the race page
    When I follow "Lähtölista"
    Then I should be on the start list page of the series
    And I should see "Jotosjoukkue"
    And I should see a start list row 1 with values:
      | name | Johnson James |
      | team_name | Special team |
    