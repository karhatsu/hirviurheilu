Feature: Generate start list
  In order to tell the competitors when is their start time
  As an official
  I need to generate the start list

  Scenario: Generate start list
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
    Then I should see "Test series - Lähtölista" within "h2"
    And I should see "Kun olet lisännyt kaikki kilpailijat, voit tällä sivulla luoda kilpailijoista lähtöluettelon." within "div.instructions"
    And I should see "Kilpailijat" within "div.main_content h3"
    And I should see "Stevensson John" within "tr#competitor_1"
    And I should see "Bears Peter" within "tr#competitor_2"
    When I fill in "15" for "Sarjan ensimmäinen numero"
    And I select "15" from "series_start_time_3i"
    And I select "marraskuu" from "series_start_time_2i"
    And I select "2010" from "series_start_time_1i"
    And I select "13" from "series_start_time_4i"
    And I select "45" from "series_start_time_5i"
    And I press "Luo lähtölista sarjalle"
    Then I should see "Test series - Lähtölista" within "h2"
    And I should see "Tälle sarjalle on luotu lähtölista. Jos sarjaan pitää lisätä vielä kilpailijoita, sinun täytyy asettaa heille lähtönumero ja lähtöaika erikseen. Voit tehdä tämän samalla, kun lisäät uuden kilpailijan." within "div.instructions"
    But I should not see "Kun olet lisännyt kaikki kilpailijat, voit tällä sivulla luoda kilpailijoista lähtöluettelon."
    And I should see "Stevensson John" within "tr#competitor_1"
    And I should see "15" within "tr#competitor_1"
    And I should see "13:45:00" within "tr#competitor_1"
    And I should see "Bears Peter" within "tr#competitor_2"
    And I should see "16" within "tr#competitor_2"
    And I should see "13:45:45" within "tr#competitor_2"
    When I follow "Kilpailijat"
    Then I should not see "Kun olet syöttänyt sarjaan kaikki kilpailijat, lisää heille alla olevan linkin avulla lähtöajat- ja numerot."
    And I should not see "Lähtöaikojen ja -numeroiden luonti..."

  Scenario: No competitors added yet
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    When I go to the official start list page of the series
    Then I should see "Tässä sarjassa ei ole vielä yhtään kilpailijaa. Kun olet lisännyt sarjaan kilpailijat, voit tällä sivulla luoda heille lähtölistan."
    But I should not see "Sarjan ensimmäinen numero"
    And I should not see "Sarjan lähtöaika"
    And I should not see "Kilpailijat" within "div.main_content"

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
    Then I should see "Sarjan ensimmäinen numero täytyy olla suurempi kuin 0" within "div.error_explanation"
    But I should not see "-1" within "tr#competitor_1"

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
    And the series has a competitor with attributes:
      | first_name | Peter |
      | last_name | Bears |
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Tee lista"
    And I fill in "" for "Sarjan ensimmäinen numero"
    And I press "Luo lähtölista sarjalle"
    Then I should see "Numeroita ei voi generoida, sillä sarjan ensimmäistä numeroa ei ole määritetty" within "div.error_explanation"
    But I should not see "0" within "tr#competitor_1"
