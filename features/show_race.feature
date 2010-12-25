Feature: Show race
  In order to see race series and other information
  As a user
  I want to see race details

  Scenario: No competitors
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:30 |
    When I go to the race page
    Then I should see "My test race" within ".main_title"
    And I should see "Test city, 01.01.2010 - 02.01.2010" within ".main_title"
    And I should see "Men 50 years" within "tr#series_1"
    And I should see "01.01.2010 13:30" within "tr#series_1"
    And I should see "Sarjaan ei ole merkitty kilpailijoita" within "tr#series_1"

  Scenario: Competitors but no start list
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:30 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    When I go to the race page
    Then I should see "Sarjan lähtöluetteloa ei ole vielä julkaistu" within "tr#series_1"

  Scenario: Start list exists
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:30 |
      | first_number | 1 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And the start list has been generated for the series
    When I go to the race page
    And I follow "Lähtölista"
    Then I should be on the start list page of the series
    When I follow "Takaisin sivulle My test race"
    Then I should be on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series

  Scenario: Don't show correct estimates when race has not finished
    Given there is a race with attributes:
      | name | My test race |
    When I go to the race page
    Then I should not see "Oikeat arviot"

  Scenario: Show correct estimates when race has finished
    Given there is a race with attributes:
      | name | My test race |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 1 |
    And the race has correct estimates with attributes:
      | min_number | 10 |
      | max_number | 100 |
      | distance1 | 70 |
      | distance2 | 80 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 9 |
      | distance1 | 50 |
      | distance2 | 60 |
    And the race has correct estimates with attributes:
      | min_number | 101 |
      | max_number | |
      | distance1 | 90 |
      | distance2 | 99 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | arrival_time | 14:01:00 |
    And the race is finished
    When I go to the race page
    Then I should see "Oikeat arviot" within "h2"
    And I should see "1-9"
    And I should see "50"
    And I should see "60"
    And I should see "10-100"
    And I should see "70"
    And I should see "80"
    And I should see "101-"
    And I should see "90"
    And I should see "99"
