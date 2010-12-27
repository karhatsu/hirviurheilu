Feature: Media
  In order to send results for media like newspapers
  As an official
  I want to get race results in a certain text format

  Scenario: No competitors
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    And I am on the official race page of "Test race"
    And I follow "Lehdistö"
    Then I should see "Test race" within ".main_title"
    And I should see "Lehdistö" within "h2"
    And I should see "Tältä sivulta voit ladata tulokset lehdistöä varten tekstimuodossa" within "div.instructions"
    And I should see "Kilpailuun ei ole lisätty yhtään kilpailijaa" within "div.warning"

  Scenario: Results for all competitors
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 10 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the race has a club "Shooting club"
    And the race has a club "Sports club"
    And the race has series with attributes:
      | name | Test series |
      | start_time | 13:00 |
      | first_number | 1 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
      | club | Sports club |
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
    And the race has series with attributes:
      | name | Another test series |
      | start_time | 14:00 |
      | first_number | 5 |
    And the series has a competitor with attributes:
      | first_name | Mary |
      | last_name | Hamilton |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tina |
      | last_name | Thomsson |
      | club | Sports club |
    And the start list has been generated for the series
    And the competitor "Mary" "Hamilton" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 15:00:10 |
    And the competitor "Tina" "Thomsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | arrival_time | 15:01:00 |
    And I have logged in
    And I am on the official race page of "Test race"
    And I follow "Lehdistö"
    Then I should see "Test race" within ".main_title"
    And I should see "Lehdistö" within "h2"
    And I should see "Tältä sivulta voit ladata tulokset lehdistöä varten tekstimuodossa" within "div.instructions"
    But I should not see "Kilpailuun ei ole lisätty yhtään kilpailijaa"
    When I press "Lataa lehdistöraportti"
    Then I should see "Sarja Test series: 1) Atkinsson Tim Sports club 1140, 2) Johnson James Shooting club 1105. Sarja Another test series: 1) Thomsson Tina Sports club 1140, 2) Hamilton Mary Shooting club 1105."

  Scenario: Results for select amount of competitors
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 10 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the race has a club "Shooting club"
    And the race has a club "Sports club"
    And the race has series with attributes:
      | name | Test series |
      | start_time | 13:00 |
      | first_number | 1 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
      | club | Sports club |
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
    And the race has series with attributes:
      | name | Another test series |
      | start_time | 14:00 |
      | first_number | 5 |
    And the series has a competitor with attributes:
      | first_name | Mary |
      | last_name | Hamilton |
      | club | Shooting club |
    And the series has a competitor with attributes:
      | first_name | Tina |
      | last_name | Thomsson |
      | club | Sports club |
    And the start list has been generated for the series
    And the competitor "Mary" "Hamilton" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 15:00:10 |
    And the competitor "Tina" "Thomsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | arrival_time | 15:01:00 |
    And I have logged in
    When I go to the official media page of "Test race"
    And I fill in "1" for "Kilpailijoiden määrä / sarja"
    And I press "Lataa lehdistöraportti"
    Then I should see "Sarja Test series: 1) Atkinsson Tim Sports club 1140. Sarja Another test series: 1) Thomsson Tina Sports club 1140."

  Scenario: Invalid amount of competitors
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
    And the race has a club "Shooting club"
    And the race has series with attributes:
      | name | Test series |
      | start_time | 13:00 |
      | first_number | 1 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And I have logged in
    When I go to the official media page of "Test race"
    And I fill in "x" for "Kilpailijoiden määrä / sarja"
    And I press "Lataa lehdistöraportti"
    Then I should see "Syötä kilpailijoiden määräksi positiivinen kokonaisluku" within "div.error"
