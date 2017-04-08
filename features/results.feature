Feature: Results
  In order to see how a race went
  As a competitor
  I want to see the race results
  
  Scenario: No competitors added for the series
    Given there is a race "My race"
    And the race has series "No competitors series"
    When I go to the results page of the series
    Then the "Kilpailut" main menu item should be selected
    And the "Tulokset" sub menu item should be selected
    And I should see "No competitors series - (Ei kilpailijoita)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Tilanne" within "h2"
    And I should see "Sarjaan ei ole lisätty kilpailijoita" in an info message
    
  Scenario: The series has no start list yet
    Given there is a race "My race" in the future
    And the race has series "My series"
    And the series has a competitor
    When I go to the results page of the series
    Then I should see "My series - (Sarja ei ole vielä alkanut)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Tilanne" within "h2"
    And I should see "Sarjan lähtöluetteloa ei ole vielä julkaistu" in an info message
    And I should not see "Lataa tulokset PDF-tiedostona"

  Scenario: The series has a start list but it has not started yet
    Given there is a race "My race" in the future
    And the race has series with attributes:
      | name | My series |
      | first_number | 1 |
      | start_time | 02:30 |
    And the series has a competitor
    And the start list has been generated for the series
    When I go to the results page of the series
    Then I should see "My series - (Sarja ei ole vielä alkanut)" within "h2"
    But I should not see "Tulokset" within "h2"
    And I should not see "Tilanne" within "h2"
    And I should see "Sarjan lähtöaika" in an info message
    And I should see "Sarjan alkuun on aikaa" in an info message
    And I should not see "Lataa tulokset PDF-tiedostona"

  Scenario: Go to see the final results of a series
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
      | finished | true |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
      | arrival_time | 02:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | arrival_time | 02:01:00 |
    And the race is finished
    And I am on the race page
    When I choose "Tulokset" from sub menu
    Then I should be on the results page of the series
    And the page title should contain "My test race"
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
      | start_time | 01:00 |
      | first_number | 50 |
      | points_method | 2 |
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
      | arrival_time | 02:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | estimate3 | 150 |
      | estimate4 | 180 |
      | arrival_time | 02:01:00 |
    And the race is finished
    And I am on the race page
    When I choose "Tulokset" from sub menu
    Then I should be on the results page of the series
    And the page title should contain "My test race"
    And I should see "Men 50 years - Tulokset" within "h2"
    And I should see "Hirvenhiihtely (sarjassa on 4 arviota, ei aikapisteitä)" in an info message
    And I should see a result row 1 with values:
      | name | Atkinsson Tim |
      | number | 51 |
      | club | Sports club |
      | points | 1140 |
      | shooting | 540 (90) |
      | estimates | 600 (0m/0m/0m/0m) |
    And I should see a result row 2 with values:
      | name | Johnson James |
      | number | 50 |
      | club | Shooting club |
      | points | 1102 |
      | shooting | 510 (85) |
      | estimates | 592 (+1m/-1m/-1m/+1m) |
    But I should not see "Juoksu"
    But I should not see "Hiihto"
    But I should not see "300 (1:00:00)"
    And I should not see "299 (1:00:10)"

  Scenario: Results for a series that gives every competitor 300 time points
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
      | sport | SKI |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
      | first_number | 50 |
      | points_method | 3 |
    And the race has correct estimates with attributes:
      | min_number | 50 |
      | max_number | 50 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the race has a club "Shooting club"
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Shooting club |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
    And the race is finished
    And I am on the race page
    When I choose "Tulokset" from sub menu
    Then I should be on the results page of the series
    And the page title should contain "My test race"
    And I should see "Men 50 years - Tulokset" within "h2"
    And I should see "Hirvenhiihtely (sarjassa on 2 arviota, kaikki saavat 300 aikapistettä)" in an info message
    And I should see a result row 1 with values:
      | name | Johnson James |
      | number | 50 |
      | club | Shooting club |
      | points | 1106 |
      | shooting | 510 (85) |
      | estimates | 296 (+1m/-1m) |
      | time | 300 |
    When I follow "Johnson James"
    Then I should be on the results page of the competitor
    And I should see "Hirvenhiihtely (sarjassa on 2 arviota, kaikki saavat 300 aikapistettä)" in an info message
    And I should see "Pisteet" within "#points h3"
    And I should see individual competitor page points 510+296+300=1106
    And I should see "Hiihto" within "#time h3"
    And I should see individual competitor page time result "01:00:00"-"-"="-"

  Scenario: See the results of an unfinished race
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
    When I choose "Tulokset" from sub menu
    Then I should be on the results page of the series
    And the page title should contain "My test race"
    And I should see "Men 50 years - Tilanne" within "h2"
    And I should see "Kilpailu on kesken. Tarkemmat arviointitiedot julkaistaan, kun kilpailu on päättynyt."
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
      | start_time | 01:00 |
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
      | arrival_time | 02:00:00 |
    And the race is finished
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And the page title should contain "My test race"
    And I should see "Men 50 years - Atkinsson Tim" within "h2"
    And I should see "Pisteet" within "#points h3"
    And I should see individual competitor page points 540+296+300=1136
    And I should see "Ammunta" within "#shooting h3"
    And I should see "90" within "#shooting"
    And I should see "Arviointi" within "#estimates h3"
    And I should see at individual competitor page estimates 111 and 129 with correct estimates 110 and 130 with distance error "+1" and "-1"
    And I should see "Juoksu" within "#time h3"
    And I should see individual competitor page time result "01:00:00"-"02:00:00"="1:00:00"

  Scenario: See the results of an individual competitor in a walking series
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
      | first_number | 50 |
      | points_method | 2 |
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
      | arrival_time | 02:00:00 |
    And the race is finished
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And I should see "Hirvikävely (sarjassa on 4 arviota, ei aikapisteitä)" in an info message
    And the page title should contain "My test race"
    And I should see "Men 50 years - Atkinsson Tim" within "h2"
    And I should see "Pisteet" within "#points h3"
    And I should see individual competitor page points 540+588=1128 without time points
    And I should see "Ammunta" within "#shooting h3"
    And I should see "90" within "#shooting"
    And I should see "Arviointi" within "#estimates h3"
    And I should see at individual competitor page estimates 111, 129, 82 and 188 with correct estimates 110, 130, 80 and 190 with distance error "+1", "-1", "+2" and "-2"
    And I should see "Juoksu" within "#time h3"
    And I should see individual competitor page time result "01:00:00"-"02:00:00"="1:00:00"

  Scenario: See the results of an individual competitor in an unfinished race
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
      | arrival_time | 02:00:00 |
    And I am on the results page of the series
    When I follow "Atkinsson Tim"
    Then I should be on the results page of the competitor
    And the page title should contain "My test race"
    And I should see "Men 50 years - Atkinsson Tim" within "h2"
    And I should see "Pisteet" within "#points h3"
    And I should see individual competitor page points 540+296+300=1136
    And I should see "Ammunta" within "#shooting h3"
    And I should see "90" within "#shooting"
    And I should see "Arviointi" within "#estimates h3"
    And I should see "Tarkemmat arviointitiedot julkaistaan, kun kilpailu on päättynyt."
    But I should not see 111, 129, 110, 130, "+1" or "-1" in individual competitor page estimates
    And I should see "Juoksu" within "#time h3"
    And I should see individual competitor page time result "01:00:00"-"02:00:00"="1:00:00"

  Scenario: See the results with national record reached mention of an individual competitor in an unfinished race
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
      | arrival_time | 02:00:00 |
    And the competitor "Tom" "Betkinsson" has the following results:
      | shots_total_input | 67 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 02:05:00 |
    And I am on the results page of the series
    And I should see "1136 SE(sivuaa)"

  Scenario: See the results with national record mention of an individual competitor in an unfinished race
    Given there is a race with attributes:
      | sport | RUN |
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
      | arrival_time | 02:00:00 |
    And the competitor "Tom" "Betkinsson" has the following results:
      | shots_total_input | 67 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 02:00:00 |
    And I am on the results page of the series
    And I should see "SE?"
    And I should see "1130 SE?"
    And I should see "998"
    But I should not see "998 SE?"

  Scenario: See the results with national record mention of an individual competitor in a finished race
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
      | finished | true |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
      | arrival_time | 02:00:00 |
    And the competitor "Tom" "Betkinsson" has the following results:
      | shots_total_input | 67 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 02:05:00 |
    And I am on the results page of the series
    And I should see "1136 SE"
    But I should not see "1136 SE sivuaa"
    But I should not see "1136 SE?"
    But I should not see "974 SE"
    But I should not see "SE?"

  Scenario: Results for series with unofficial competitors
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-07-15 |
      | location | Test city |
      | start_interval_seconds | 60 |
      | finished | true |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
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
      | unofficial | true |
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
    And the race is finished
    And I am on the race page
    When I choose "Tulokset" from sub menu
    Then I should be on the results page of the series
    And the page title should contain "My test race"
    And I should see "Men 50 years - Tulokset" within "h2"
    And I should see a result row 1 with values:
      | name | Johnson James |
      | number | 50 |
      | club | Shooting club |
      | points | 1106 |
      | shooting | 510 (85) |
      | estimates | 296 (+1m/-1m) |
      | time | 300 (1:00:10) |
    And I should see a result row 2 with values:
      | name | Atkinsson Tim (epäv.) |
      | number | 51 |
      | club | Sports club |
      | points | 1140 |
      | shooting | 540 (90) |
      | estimates | 300 (0m/0m) |
      | time | 300 (1:00:00) |
    When I follow "Näytä epäviralliset tulokset (kaikki kilpailijat mukana)"
    Then I should see "Men 50 years - Tulokset - Kaikki kilpailijat" within "h2"
    And I should see a result row 1 with values:
      | name | Atkinsson Tim (epäv.) |
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
    When I follow "Näytä viralliset tulokset"
    Then I should see "Men 50 years - Tulokset" within "h2"

  Scenario: Results show reference time for each competitor
    Given there is a race with attributes:
      | name | My test race |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
      | first_number | 50 |
    And the series has a competitor "James" "Johnson"
    And the series has a competitor "Tim" "Atkinsson"
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | arrival_time | 01:30:25 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | arrival_time | 01:40:00 |
    And I am on the results page of the series
    Then the result row 1 should have time "30:25" with reference time "30:25"
    And the result row 2 should have time "39:00" with reference time "30:25"

  Scenario: Results for series where some age groups have shorter trip
    Given there is a race with attributes:
      | name | My test race |
      | start_interval_seconds | 60 |
    And the race has series with attributes:
      | name | M70 |
      | start_time | 01:00 |
      | first_number | 50 |
    And the series has an age group "M75" with 2 minimum competitors for own comparison time
    And the series has an age group "M80" with shorter trip
    And the series has a competitor "James" "Johnson"
    And the series has a competitor "Tim" "Atkinsson"
    And the competitor belongs to an age group "M75"
    And the series has a competitor "Old" "Grandpa"
    And the competitor belongs to an age group "M80"
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | arrival_time | 01:30:25 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | arrival_time | 01:40:00 |
    And the competitor "Old" "Grandpa" has the following results:
      | arrival_time | 01:20:00 |
    And I am on the results page of the series
    Then the result row 1 should have time "18:00" with reference time "18:00"
    And the result row 2 should have time "30:25" with reference time "30:25"
    And the result row 3 should have time "39:00" with reference time "30:25"
    And I should see "Ikäryhmällä M80 on lyhennetty matka." in the second info message

  Scenario: Multiple age groups have shorter trip
    Given there is a race "Race with shorter trip age groups"
    And the race has series with attributes:
      | name | M70 |
      | start_time | 01:00 |
      | first_number | 50 |
    And the series has a competitor "James" "Johnson"
    And the series has an age group "M80" with shorter trip
    And the series has an age group "M90" with shorter trip
    And the start list has been generated for the series
    And I am on the results page of the series
    Then I should see "Ikäryhmillä M80, M90 on lyhennetty matka." in the second info message
