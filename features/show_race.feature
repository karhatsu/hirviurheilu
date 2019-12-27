Feature: Show race
  In order to see race series and other information
  As a user
  I want to see race details

  Scenario: No competitors
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2029-01-01 |
      | start_time | 10:00 |
      | end_date | 2029-01-02 |
      | location | Test city |
      | public_message | Tiedote kilpailijoille ja kotikatsojille |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 03:30 |
    When I go to the race page
    Then the "Kilpailut" main menu item should be selected
    And the "Kilpailun etusivu" sub menu item should be selected
    And the page title should contain "My test race"
    And the page title should contain "Test city, 01.01.2029 - 02.01.2029"
    And I should see "Tiedote kilpailijoille ja kotikatsojille" within ".public_message"
    And I should see "Kilpailun alkuun on aikaa noin 9 vuotta. Kilpailu alkaa 10:00." in an info message
    And I should see "Men 50 years (13:30)" within ".button"
    But I should not see "Kaikkien sarjojen lähtöajat (PDF)"

  Scenario: Competitors but no start list, nor race start time
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:30 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    When I go to the race page
    Then I should see "Kaikkien sarjojen lähtöajat (PDF)"
    But I should not see "Kilpailu alkaa"

  Scenario: Race starts in 7 days
    Given there is a race "Future race" that starts in 7 days
    And I go to the race page of "Future race"
    Then I should see "Kilpailun alkuun on aikaa 7 päivää"

  Scenario: Start list exists
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:30 |
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
    When I choose "Tulokset" from sub menu
    Then I should be on the results page of the series

  Scenario: Don't show start time column when competitor order is mixed between series
    Given there is a race with attributes:
      | name | My test race |
      | start_order | 2 |
    And the race has series with attributes:
      | name | Women |
      | start_time | 00:45 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | start_time | 01:30 |
      | number | 100 |
    When I go to the race page
    Then I should see "Women"
    But I should not see "Lähtöaika"
    And I should not see "00:45"
    And I should not see "01:30"

  Scenario: Don't show correct estimates when race has not finished
    Given there is a race with attributes:
      | name | My test race |
    When I go to the race page
    Then I should not see "Oikeat etäisyydet"

  Scenario: Don't show race start time or all series start list PDF link when race has finished
    Given there is a race with attributes:
      | name | My test race |
      | start_time | 09:30 |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 01:00 |
      | first_number | 1 |
    And the race has correct estimates with attributes:
      | min_number | 55 |
      | max_number | 55 |
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
    But I should not see "Kilpailu alkaa"
    But I should not see "Kilpailu alkoi"
    But I should not see "Kaikkien sarjojen lähtöajat (PDF)"

  Scenario: Show link to cup results when the race belongs to a cup
    Given there is a cup "Test cup"
    And there is a race "Test race"
    And the race belongs to the cup
    And I am on the race page
    Then I should see "Cup-kilpailu"
    And I should see "Test cup" within ".button"
    When I follow "Test cup"
    Then I should be on the cup page of "Test cup"
