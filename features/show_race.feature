Feature: Show race
  In order to see race series and other information
  As a user
  I want to see race details

  Scenario: No competitors
    Given there is a race with attributes:
      | name | My test race |
      | start_date | 2010-01-01 |
      | start_time | 10:00 |
      | end_date | 2010-01-02 |
      | location | Test city |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 03:30 |
    When I go to the race page
    Then the "Kilpailut" main menu item should be selected
    And the "Kilpailun etusivu" sub menu item should be selected
    And the page title should contain "My test race"
    And the page title should contain "Test city, 01.01.2010 - 02.01.2010"
    And I should see "Men 50 years" within "tr#series_1"
    And I should see "01.01.2010 13:30" within "tr#series_1"
    And I should see "Sarjaan ei ole lisätty kilpailijoita" within "tr#series_1"

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
    
  Scenario: Don't show start time column when competitor order is mixed between series
    Given there is a race with attributes:
      | name | My test race |
      | start_order | 2 |
    And the race has series with attributes:
      | name | Women |
      | start_time | 12:45 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | start_time | 13:30 |
      | number | 100 |
    When I go to the race page
    Then I should see "Women"
    But I should not see "Lähtöaika"
    And I should not see "12:45"
    And I should not see "13:30"

  Scenario: Don't show correct estimates when race has not finished
    Given there is a race with attributes:
      | name | My test race |
    When I go to the race page
    Then I should not see "Oikeat etäisyydet"

  Scenario: Show correct estimates when race has finished
    Given there is a race with attributes:
      | name | My test race |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
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
    Then I should see /Oikeat etäisyydet/ within "h3"
    And I should see "Oikea etäisyys 1"
    And I should see "Oikea etäisyys 2"
    But I should not see "Oikea etäisyys 3"
    But I should not see "Oikea etäisyys 4"
    And I should see "1-9"
    And I should see "50"
    And I should see "60"
    And I should see "55"
    But I should not see "55-55"
    And I should see "70"
    And I should see "80"
    And I should see "101-"
    And I should see "90"
    And I should see "99"

  Scenario: Show correct estimates also for walking series
    Given there is a race with attributes:
      | name | My test race |
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 13:00 |
      | first_number | 1 |
      | estimates | 4 |
    And the race has correct estimates with attributes:
      | min_number | 55 |
      | max_number | 55 |
      | distance1 | 70 |
      | distance2 | 80 |
      | distance3 | 110 |
      | distance4 | 120 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 9 |
      | distance1 | 50 |
      | distance2 | 60 |
      | distance3 | 171 |
      | distance4 | 181 |
    And the race has correct estimates with attributes:
      | min_number | 101 |
      | max_number | |
      | distance1 | 90 |
      | distance2 | 99 |
      | distance3 | 153 |
      | distance4 | 156 |
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
      | estimate3 | 111 |
      | estimate4 | 129 |
      | arrival_time | 14:00:10 |
    And the competitor "Tim" "Atkinsson" has the following results:
      | shots_total_input | 90 |
      | estimate1 | 110 |
      | estimate2 | 130 |
      | estimate3 | 110 |
      | estimate4 | 130 |
      | arrival_time | 14:01:00 |
    And the race is finished
    When I go to the race page
    Then I should see /Oikeat etäisyydet/ within "h3"
    And I should see "Oikea etäisyys 1"
    And I should see "Oikea etäisyys 2"
    And I should see "Oikea etäisyys 3"
    And I should see "Oikea etäisyys 4"
    And I should see "1-9"
    And I should see "50"
    And I should see "60"
    And I should see "55"
    And I should see "110"
    And I should see "120"
    But I should not see "55-55"
    And I should see "70"
    And I should see "80"
    And I should see "171"
    And I should see "181"
    And I should see "101-"
    And I should see "90"
    And I should see "99"
    And I should see "153"
    And I should see "156"
    
  Scenario: Show link to cup results when the race belongs to a cup
    Given there is a cup "Test cup"
    And there is a race "Test race"
    And the race belongs to the cup
    And I am on the race page
    Then I should see "Cup-kilpailu"
    And I should see "Tämä kilpailu on cup-kilpailun Test cup osakilpailu"
    When I follow "Test cup"
    Then I should be on the cup page of "Test cup"
