Feature: Media
  In order to send results for media like newspapers
  As an official or club/district chairman etc
  I want to get race results in a certain text format

  Scenario: No competitors
    Given there is a race with attributes:
      | name | Test race |
    And the race has series with attributes:
      | name | Test series |
    And I am on the race page of "Test race"
    And I follow "Lehdistö"
    Then I should see "Test race" within ".main_title"
    And the "Lehdistö" sub menu item should be selected
    And I should see "Lehdistö" within "h2"
    And I should see "Tältä sivulta voit ladata tulokset lehdistöä varten tekstimuodossa" within "div.info"
    And I should see "Kilpailuun ei ole lisätty yhtään kilpailijaa" within "div.warning"

  Scenario: Results for all competitors
    Given there is a race with attributes:
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
    And the race has series "Empty series"
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
    And I am on the race page of "Test race"
    And I follow "Lehdistö"
    Then I should see "Test race" within ".main_title"
    And I should see "Lehdistö" within "h2"
    And I should see "Tältä sivulta voit ladata tulokset lehdistöä varten tekstimuodossa" within "div.info"
    But I should not see "Kilpailuun ei ole lisätty yhtään kilpailijaa"
    When I press "Lataa lehdistöraportti"
    Then I should see "Sarja Another test series: 1) Thomsson Tina Sports club 1140, 2) Hamilton Mary Shooting club 1105. Sarja Test series: 1) Atkinsson Tim Sports club 1140, 2) Johnson James Shooting club 1105."
    But I should not see "Empty series"

  Scenario: Results for select amount of competitors and for certain club
    Given there is a race with attributes:
      | name | Test race |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 10 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the race has a club "Club A"
    And the race has a club "Club B"
    And the race has a club "Club C"
    And the race has a club "Club D"
    And the race has series with attributes:
      | name | Test series |
      | start_time | 13:00 |
      | first_number | 1 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Club A |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
      | club | Club B |
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
      | club | Club C |
    And the series has a competitor with attributes:
      | first_name | Tina |
      | last_name | Thomsson |
      | club | Club D |
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
    When I go to the media page of "Test race"
    And I fill in "1" for "Kilpailijoiden määrä / sarja"
    And I select "Club C" from "Lisäksi kaikki kilpailijat piiristä/seurasta"
    And I press "Lataa lehdistöraportti"
    Then I should see "Sarja Another test series: 1) Thomsson Tina Club D 1140, 2) Hamilton Mary Club C 1105. Sarja Test series: 1) Atkinsson Tim Club B 1140."

  Scenario: Invalid amount of competitors
    Given there is a race with attributes:
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
    When I go to the media page of "Test race"
    And I fill in "x" for "Kilpailijoiden määrä / sarja"
    And I press "Lataa lehdistöraportti"
    Then I should see "Syötä kilpailijoiden määräksi positiivinen kokonaisluku" within "div.error"
