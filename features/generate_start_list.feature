Feature: Generate start list
  In order to tell the competitors when is their start time
  As an official
  I need to generate the start list

  Scenario: Generate start list
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-15 |
      | start_time | 10:30 |
      | start_interval_seconds | 45 |
    And the race has series with attributes:
      | name | Test series |
    And the series has a competitor with attributes:
      | first_name | John |
      | last_name | Stevensson |
    And the series has a competitor with attributes:
      | first_name | Peter |
      | last_name | Bears |
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Tee lista"
    Then I should see "Test series - Kilpailijat" within "h2"
    And the official main menu item should be selected
    And the "Kilpailijat" sub menu item should be selected
    And I should see "Kun olet syöttänyt sarjaan kaikki kilpailijat, lisää heille alla olevan lomakkeen avulla lähtöajat- ja numerot." in an info message
    When I fill in "15" for "Sarjan ensimmäinen numero"
    And I select "02" from "series_start_time_4i"
    And I select "45" from "series_start_time_5i"
    And I choose "order_method_0"
    And I press "Luo lähtölista sarjalle"
    Then I should see "Test series - Kilpailijat" within "h2"
    And the "Sarjan ensimmäinen numero" field should contain "15"
    And the "series_start_time_4i" field should contain "02"
    And the "series_start_time_5i" field should contain "45"
    And I should not see "Kun olet syöttänyt sarjaan kaikki kilpailijat, lisää heille alla olevan lomakkeen avulla lähtöajat- ja numerot."
    And I should see competitor 15 "Stevensson John" with start time "02:45:00 (13:15:00)" in card 1
    And I should see competitor 16 "Bears Peter" with start time "02:45:45 (13:15:45)" in card 2

  Scenario: Propose next number and start time for the second series
    Given I am an official
    And I have logged in
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-15 |
      | start_interval_seconds | 45 |
    And the race has series with attributes:
      | name | Test series |
      | first_number | 10 |
      | start_time | 01:45:00 |
    And the series has a competitor
    And the series has a competitor
    And the series has a competitor
    And the start list has been generated for the series
    And the race has series with attributes:
      | name | Another series |
    And the series has a competitor with attributes:
      | first_name | Mathew |
      | last_name | Peterson |
      | number |  |
    When I go to the official competitors page of the series
    Then the "Sarjan ensimmäinen numero" field should contain "13"
    And the "series_start_time_4i" field should contain "01"
    And the "series_start_time_5i" field should contain "47"
    And the "series_start_time_6i" field should contain "15"
    When I choose "Test series" from third level menu
    Then the "Sarjan ensimmäinen numero" field should contain "10"
    And the "series_start_time_4i" field should contain "01"
    And the "series_start_time_5i" field should contain "45"
    And the "series_start_time_6i" field should contain "00"

  Scenario: No competitors added yet
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    When I go to the official competitors page of the series
    Then I should not see "Sarjan ensimmäinen numero"
    And I should not see "Sarjan lähtöaika"

  Scenario: Invalid series values
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-15 |
      | start_interval_seconds | 45 |
    And the race has series with attributes:
      | name | Test series |
    And the series has a competitor with attributes:
      | first_name | John |
      | last_name | Stevensson |
    And the series has a competitor with attributes:
      | first_name | Peter |
      | last_name | Bears |
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Tee lista"
    And I fill in "-1" for "Sarjan ensimmäinen numero"
    And I press "Luo lähtölista sarjalle"
    Then I should see "Sarjan ensimmäinen numero täytyy olla suurempi tai yhtä suuri kuin 0" in an error message

  Scenario: Missing values for generation
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-15 |
      | start_interval_seconds | 45 |
    And the race has series with attributes:
      | name | Test series |
    And the series has a competitor with attributes:
      | first_name | John |
      | last_name | Stevensson |
      | number |  |
    And the series has a competitor with attributes:
      | first_name | Peter |
      | last_name | Bears |
      | number |  |
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Tee lista"
    And I fill in "" for "Sarjan ensimmäinen numero"
    And I press "Luo lähtölista sarjalle"
    Then I should see "Numeroita ei voi generoida, sillä sarjan ensimmäistä numeroa ei ole määritetty" in an error message

  Scenario: Don't show start list form when some competitor has an arrival time
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-15 |
      | start_interval_seconds | 45 |
    And the race has series with attributes:
      | name | Test series |
      | first_number | 1 |
      | start_time | 00:00 |
    And the series has a competitor with attributes:
      | first_name | John |
      | last_name | Stevensson |
    And the series has a competitor with attributes:
      | first_name | Peter |
      | last_name | Bears |
    And the start list has been generated for the series
    And the competitor "Peter" "Bears" has the following results:
      | arrival_time | 01:00:10 |
    And I have logged in
    When I am on the official competitors page of the series
    Then I should not see "Sarjan ensimmäinen numero"
    And I should not see "Sarjan lähtöaika"
    And I should not see "Kilpailijoiden järjestys"

  Scenario: If official wants so, there is no need to generate start list
    Given I am an official
    And I have logged in
    And I am on the new race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test location |
    And I select "Test district" from "race_district_id"
    And I press "Lisää kilpailu"
    Then I should see "Kilpailijoiden lähtöjärjestys" in an error message
    When I choose "Sarjat sekaisin"
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    When I follow "Kilpailijat"
    And I follow "Lisää kilpailija"
    Then I should see "Numero"
    And I should see "Lähtöaika"

  Scenario: Don't show start list form when start order is mixed between series
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_order | 2 |
    And the race has a club "Test club"
    And the race has series "Test series"
    And the series has a competitor with attributes:
      | first_name | Teppo |
      | last_name | Testinen |
      | club | Test club |
      | start_time | 01:00:00 |
      | number | 1 |
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "1 hlö"
    Then I should not see "Valitse lähtöajaksi"
    And I should not see "Sarjan ensimmäinen numero"
    And I should not see "Kilpailijoiden järjestys"
    But I should see "Testinen Teppo"
