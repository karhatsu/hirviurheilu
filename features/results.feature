Feature: Results
  In order to see how a race went
  As a competitor
  I want to see the race results
  
  Scenario: No competitors added for the series
    Given there is a race "My race"
    And the race has series "No competitors series"
    When I go to the results page of the series
    Then the "Tulokset" sub menu item should be selected
    And I should see "No competitors series - (Ei kilpailijoita)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Väliaikatulokset" within "h2"
    And I should see "Tähän sarjaan ei ole merkitty kilpailijoita." within "div.info"
    
  Scenario: The series has no start list yet
    Given there is a race "My race" in the future
    And the race has series "My series"
    And the series has a competitor
    When I go to the results page of the series
    Then I should see "My series - (Sarja ei ole vielä alkanut)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Väliaikatulokset" within "h2"
    And I should see "Sarjan lähtölistaa ei ole vielä luotu" within "div.info"
    And I should not see "Lataa tulokset pdf-tiedostona"

  Scenario: The series has a start list but it has not started yet
    Given there is a race "My race" in the future
    And the race has series with attributes:
      | name | My series |
      | first_number | 1 |
      | start_time | 14:30 |
    And the series has a competitor
    And the start list has been generated for the series
    When I go to the results page of the series
    Then I should see "My series - (Sarja ei ole vielä alkanut)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Väliaikatulokset" within "h2"
    And I should see "Sarjan lähtöaika" within "div.info"
    And I should see "Sarjan alkuun on aikaa" within "div.info"
    And I should not see "Lataa tulokset pdf-tiedostona"

  Scenario: Go to see the final results of a series
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
      | finished | true |
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
    And I am on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series
    And I should see "My test race" within ".main_title"
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

  Scenario: Results for a walking series (no time points, 4 estimates)
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
      | no_time_points | true |
      | estimates | 4 |
    And the race has correct estimates with attributes:
      | min_number | 50 |
      | max_number | 51 |
      | distance1 | 110 |
      | distance2 | 130 |
      | distance3 | 150 |
      | distance4 | 180 |
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
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | estimate3 | 149 |
      | estimate4 | 181 |
      | arrival_time | 14:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | estimate3 | 150 |
      | estimate4 | 180 |
      | arrival_time | 14:01:00 |
    And the race is finished
    And I am on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series
    And I should see "My test race" within ".main_title"
    And I should see "Men 50 years - Tulokset" within "h2"
    And I should see "Tälle sarjalle ei lasketa aikapisteitä." within "div.info"
    And I should see "Tässä sarjassa on 4 arviomatkaa." within "div.info"
    And I should see a result row 1 with values:
      | name | Atkinsson Tim |
      | number | 51 |
      | club | Sports club |
      | points | 1140 |
      | shooting | 540 (90) |
      | estimates | 600 (0m/0m/0m/0m) |
      | time | (1:00:00) |
    And I should see a result row 2 with values:
      | name | Johnson James |
      | number | 50 |
      | club | Shooting club |
      | points | 1102 |
      | shooting | 510 (85) |
      | estimates | 592 (+1m/-1m/-1m/+1m) |
      | time | (1:00:10) |
    But I should not see "300 (1:00:00)"
    And I should not see "299 (1:00:10)"

  Scenario: See the results of an unfinished race
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
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
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
    And I am on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series
    And I should see "My test race" within ".main_title"
    And I should see "Men 50 years - Väliaikatulokset" within "h2"
    And I should see "Kilpailu on kesken. Tarkemmat arviointitiedot julkaistaan kilpailun päätyttyä."
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
      | start_time | 13:00 |
      | first_number | 50 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And the race is finished
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And I should see "My test race" within ".main_title"
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

  Scenario: See the results of an individual competitor in a walking series
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
      | no_time_points | true |
      | estimates | 4 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
      | distance3 | 80 |
      | distance4 | 190 |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | estimate3 | 82 |
      | estimate4 | 188 |
      | arrival_time | 14:00:00 |
    And the race is finished
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And I should see "Tälle sarjalle ei lasketa aikapisteitä." within "div.info"
    And I should see "Tässä sarjassa on 4 arviomatkaa." within "div.info"
    And I should see "My test race" within ".main_title"
    And I should see "Men 50 years - Atkinsson Tim" within "h2"
    And I should see "Pisteet" within "#points h3"
    And I should see "540" within "#points td"
    And I should see "588" within "#points td"
    But I should not see "300" within "#points td"
    And I should see "1128" within "#points td"
    And I should see "Ammunta" within "#shooting h3"
    And I should see "90" within "#shooting"
    And I should see "Arviointi" within "#estimates h3"
    And I should see "111" within "#estimates td"
    And I should see "129" within "#estimates td"
    And I should see "82" within "#estimates td"
    And I should see "188" within "#estimates td"
    And I should see "110" within "#estimates td"
    And I should see "130" within "#estimates td"
    And I should see "80" within "#estimates td"
    And I should see "190" within "#estimates td"
    And I should see "+1" within "#estimates td"
    And I should see "-1" within "#estimates td"
    And I should see "+2" within "#estimates td"
    And I should see "-2" within "#estimates td"
    And I should see "Juoksu" within "#time h3"
    And I should see "13:00:00" within "#time td"
    And I should see "14:00:00" within "#time td"
    And I should see "1:00:00" within "#time td"

  Scenario: See the results of an individual competitor in an unfinished race
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
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
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And I should see "My test race" within ".main_title"
    And I should see "Men 50 years - Atkinsson Tim" within "h2"
    And I should see "Pisteet" within "#points h3"
    And I should see "540" within "#points td"
    And I should see "296" within "#points td"
    And I should see "300" within "#points td"
    And I should see "1136" within "#points td"
    And I should see "Ammunta" within "#shooting h3"
    And I should see "90" within "#shooting"
    And I should see "Arviointi" within "#estimates h3"
    And I should not see "111" within "#estimates"
    And I should not see "129" within "#estimates"
    And I should not see "110" within "#estimates"
    And I should not see "130" within "#estimates"
    And I should not see "+1" within "#estimates"
    And I should not see "-1" within "#estimates"
    And I should see "Tarkemmat arviointitiedot näytetään kilpailun päätyttyä."
    And I should see "Juoksu" within "#time h3"
    And I should see "13:00:00" within "#time td"
    And I should see "14:00:00" within "#time td"
    And I should see "1:00:00" within "#time td"

  Scenario: See the results with national record reached mention of an individul competitor in an unfinished race
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
      | national_record | 1136 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the series has a competitor with attributes:
      | first_name | Tom |
      | last_name | Betkinsson |
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And the competitor "Tom" "Betkinsson" has the following results:
      | shots_total_input | 67 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:05:00 |
    And I am on the results page of the series
    And I should see "SE" within "td"
    And I should see "sivuaa" within "td"
    And I should see "1136 SE(sivuaa)?" within "td"

  Scenario: See the results with national record mention of an individual competitor in an unfinished race
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
      | national_record | 950 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the series has a competitor with attributes:
      | first_name | Tom |
      | last_name | Betkinsson |
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And the competitor "Tom" "Betkinsson" has the following results:
      | shots_total_input | 67 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And I am on the results page of the series
    And I should see "SE?" within "td"
    And I should see "1130 SE?" within "td"
    And I should see "998" within "td"
    But I should not see "998 SE?" within "td"

  Scenario: See the results with national record mention of an individual competitor in a finished race
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
      | finished | true |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 50 |
      | national_record | 1000 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Atkinsson |
    And the series has a competitor with attributes:
      | first_name | Tom |
      | last_name | Betkinsson |
    And the start list has been generated for the series
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:00 |
    And the competitor "Tom" "Betkinsson" has the following results:
      | shots_total_input | 67 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:05:00 |
    And I am on the results page of the series
    And I should see "SE" within "td"
    And I should see "1136" within "td"
    And I should see "1136 SE" within "td"
    And I should see "974" within "td"
    But I should not see "1136 SE sivuaa" within "td"
    But I should not see "1136 SE?" within "td"
    But I should not see "974 SE" within "td"
    But I should not see "SE?" within "td"

