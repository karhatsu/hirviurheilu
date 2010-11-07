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
      | start_time | 2010-01-01 13:30 |
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
      | start_time | 2010-01-01 13:30 |
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
      | start_time | 2010-01-01 13:30 |
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
