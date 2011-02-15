Feature: Publish race
  In order to let the competitors and anyone who is interested to see the race results
  As a person using the software offline
  I want to publish the finished race to an online service

  Scenario: No publishing in online
    Given I am an official
    And I have an ongoing race "Online race"
    And I have logged in
    And I am on the official race page of "Online race"
    Then I should not see "Julkaise"
    When I go to the publish race page of "Online race"
    Then I should be on the official race page of "Online race"

  Scenario: Unfinished race
    Given I use the software offline
    And I have an ongoing race "Offline race"
    And I am on the official race page of "Offline race"
    And I follow "Julkaise"
    Then I should see "Offline race" within "div.main_title"
    And I should see "Julkaise kilpailu internetissä" within "h2"
    And I should see "Tällä sivulla voit julkaista kilpailun lopulliset tulokset internetissä. Tarvitset vain tunnukset Hirviurheilu-palveluun (http://www.hirviurheilu.com). Julkaiseminen ei maksa mitään." within "div.info"
    And I should see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi." within "div.error"

  # In this scenario the race is published to the same system which is relevant only for testing.
  # The first user in the scenario is automatically used in the offline state.
  # The second user is meant for receiving the uploaded race.
  Scenario: Publish finished race
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given there is an official with email "online@hirviurheilu.com" and password "online"
    Given I use the software offline
    And I have an ongoing race "Offline race"
    And the race has series with attributes:
      | name | Offline series |
      | first_number | 1 |
      | start_time | 13:00 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 1 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:00:10 |
    And the race is finished
    And I am on the official race page of "Offline race"
    And I follow "Julkaise"
    Then I should be on the publish race page of "Offline race"
    But I should not see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi."
    And I should see "Julkaistava kilpailu: Offline race"
    When I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I select "Integration test" from "Kohde"
    And I press "Julkaise"
    Then I should see "Kilpailun tiedot ladattu kohdejärjestelmään" within "div.success"
    Given I use the software online again
    And I am on the home page
    And I follow "Kirjaudu sisään"
    And I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I press "Kirjaudu"
    And I follow "Toimitsijan sivut"
    Then I should be on the official index page
    And I should see "Offline race"
