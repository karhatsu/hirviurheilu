Feature: Team competition results
  In order to know what clubs were the best
  As a user
  I want to see the team competition results

  Scenario: Show results
    Given there is a race with attributes:
      | name | My test race |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
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
    And the series has a competitor with attributes:
      | first_name | John |
      | last_name | Stewards |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Peter |
      | last_name | Smith |
      | club | Sports club |
    And the series has a competitor with attributes:
      | first_name | Gilbert |
      | last_name | Worst |
      | club | Shooting club |
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
    And the competitor "John" "Stewards" has the following results:
      | shots_total_input | 88 |
      | estimate1 | 118 |
      | estimate2 | 125 |
      | arrival_time | 14:02:10 |
    And the competitor "Peter" "Smith" has the following results:
      | shots_total_input | 94 |
      | estimate1 | 100 |
      | estimate2 | 131 |
      | arrival_time | 14:03:00 |
    And the competitor "Gilbert" "Worst" has the following results:
      | shots_total_input | 70 |
      | estimate1 | 100 |
      | estimate2 | 150 |
      | arrival_time | 14:11:00 |
    And the race has a team competition "Teams" with 2 competitors / team
    And the team competition contains the series "Men 50 years"
    And the race is finished
    And I am on the race page of "My test race"
    When I follow "Joukkuekilpailu"
    Then the "Joukkuekilpailut" sub menu item should be selected
    And I should see "Teams - Tulokset" within "h2"
    And I should see "1." within "tr#team_1"
    And I should see "Sports club" within "tr#team_1"
    And I should see "2282" within "tr#team_1"
    And I should see "2." within "tr#team_2"
    And I should see "Shooting club" within "tr#team_2"
    And I should see "2206" within "tr#team_2"
    And I should see a team 1 competitor row 1 with values:
      | name | Smith Peter |
      | series | Men 50 years |
      | points | 1142 |
      | shooting | 564 (94) |
      | estimates | 278 (-10m/+1m) |
      | time | 300 (1:00:00) |
    And I should see a team 1 competitor row 2 with values:
      | name | Atkinsson Tim |
      | series | Men 50 years |
      | points | 1140 |
      | shooting | 540 (90) |
      | estimates | 300 (0m/0m) |
      | time | 300 (1:00:00) |
