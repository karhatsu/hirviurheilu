Feature: Media
  In order to send results for media like newspapers
  As an official or club/district chairman etc
  I want to get race results in a certain text format

  Scenario: Race not finished yet
    Given there is a race "Test race"
    When I go to the race page of "Test race"
    And I follow "Lehdistö"
    Then the page title should contain "Test race"
    And the "Lehdistö" sub menu item should be selected
    And I should see "Lehdistö" within "h2"
    And I should see "Tältä sivulta voit ladata lehdistöraportin, kun kilpailu on päättynyt" in an info message
    But I should not see "Kilpailijoiden määrä / sarja"
    And I should not see "Lisäksi kaikki kilpailijat"

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
      | start_time | 01:00 |
      | first_number | 1 |
      | national_record | 1139 |
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
      | arrival_time | 02:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | arrival_time | 02:01:00 |
    And the race has series with attributes:
      | name | Another test series |
      | start_time | 02:00 |
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
    And the race is finished
    And I am on the race page of "Test race"
    And I follow "Lehdistö"
    Then the page title should contain "Test race"
    And I should see "Lehdistö" within "h2"
    And I should see "Tältä sivulta voit ladata lehdistöraportin" in an info message
    But I should not see "kun kilpailu on päättynyt"
    When I press "Lataa lehdistöraportti"
    Then I should see "Sarja Another test series: 1) Thomsson Tina Sports club 1140, 2) Hamilton Mary Shooting club 1105. Sarja Test series: 1) Atkinsson Tim Sports club 1140 (SE), 2) Johnson James Shooting club 1105." within "div.main_content"
    But I should not see "Empty series" within "div.main_content"

  Scenario: Results for selected amount of competitors and for certain club
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
      | start_time | 01:00 |
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
      | arrival_time | 02:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | arrival_time | 02:01:00 |
    And the race has series with attributes:
      | name | Another test series |
      | start_time | 02:00 |
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
    And the race is finished
    When I go to the media page of "Test race"
    And I fill in "x" for "Kilpailijoiden määrä / sarja"
    And I press "Lataa lehdistöraportti"
    Then I should see "Kilpailijoiden määrä virheellinen" in an error message
    When I fill in "1" for "Kilpailijoiden määrä / sarja"
    And I select "Club C" from "Lisäksi kaikki kilpailijat seurasta"
    And I press "Lataa lehdistöraportti"
    Then I should see "Sarja Another test series: 1) Thomsson Tina Club D 1140, 2) Hamilton Mary Club C 1105. Sarja Test series: 1) Atkinsson Tim Club B 1140."
