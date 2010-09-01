Feature: Results
  In order to see how a race went
  As a user
  I want to see the race results

  Scenario: Go to see the final results of a series
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 2010-07-15 13:00 |
      | first_number | 50 |
      | correct_estimate1 | 110 |
      | correct_estimate2 | 130 |
    And there is a club "Shooting club"
    And there is a club "Sports club"
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
      | club | Sports club |
    And there are numbers generated for the series
    And there are start times generated for the series
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
    And I am on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series
    And I should see "My test race" within "h1"
    And I should see "Men 50 years - Tulokset" within "h2"
    And I should see a result row 1 with values:
      | name | Atkinsson Tim |
      | number | 51 |
      | club | Sports club |
      | points | 1140 |
      | shooting | 540 (90) |
      | estimates | 300 (0m/0m) |
      | time | 300 (1:00:00) |
    And I should see a result row 2 with values:
      | name | Johnson James |
      | number | 50 |
      | club | Shooting club |
      | points | 1105 |
      | shooting | 510 (85) |
      | estimates | 296 (+1m/-1m) |
      | time | 299 (1:00:10) |

  Scenario: See the results of an unfinished race
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 2010-07-15 13:00 |
      | first_number | 50 |
      | correct_estimate1 | 110 |
      | correct_estimate2 | 130 |
    And there is a club "Shooting club"
    And there is a club "Sports club"
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
      | club | Sports club |
    And there are numbers generated for the series
    And there are start times generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
    And I am on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series
    And I should see "My test race" within "h1"
    And I should see "Men 50 years - Tulokset" within "h2"
    And I should see a result row 1 with values:
      | name | Atkinsson Tim |
      | number | 51 |
      | club | Sports club |
      | points | (840) |
      | shooting | 540 (90) |
      | estimates | 300 |
      | time | - |
    And I should not see "300 (0m/0m)"
    And I should see a result row 2 with values:
      | name | Johnson James |
      | number | 50 |
      | club | Shooting club |
      | points | - |
      | shooting | - |
      | estimates | - |
      | time | - |

  Scenario: See the results of an individual competitor
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 2010-07-15 13:00 |
      | first_number | 50 |
      | correct_estimate1 | 110 |
      | correct_estimate2 | 130 |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And there are numbers generated for the series
    And there are start times generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And the race is finished
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And I should see "My test race" within "h1"
    And I should see "Men 50 years - Atkinsson Tim" within "h2"
    And I should see "Pisteet" within "#points h3"
    And I should see "540" within "#points td"
    And I should see "296" within "#points td"
    And I should see "300" within "#points td"
    And I should see "1136" within "#points td"
    And I should see "Ammunta" within "#shooting h3"
    And I should see "90" within "#shooting"
    And I should see "Arviointi" within "#estimates h3"
    And I should see "111" within "#estimates td"
    And I should see "129" within "#estimates td"
    And I should see "110" within "#estimates td"
    And I should see "130" within "#estimates td"
    And I should see "+1" within "#estimates td"
    And I should see "-1" within "#estimates td"
    And I should see "Juoksu" within "#time h3"
    And I should see "13:00:00" within "#time td"
    And I should see "14:00:00" within "#time td"
    And I should see "1:00:00" within "#time td"
