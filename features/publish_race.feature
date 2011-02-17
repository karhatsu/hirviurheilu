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
    And I should see "Tällä sivulla voit julkaista kilpailun lopulliset tulokset internetissä, Hirviurheilu-palvelussa." within "div.info"
    And I should see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi." within "div.error"

  # In this scenario the race is published to the same system which is relevant only for testing.
  # The first user in the scenario is automatically used in the offline state.
  # The second user is meant for receiving the uploaded race.
  Scenario: Publish finished race
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given there is an official "Robert" "Onliner" with email "online@hirviurheilu.com" and password "online"
    Given I use the software offline
    And I have an ongoing race with attributes:
      | name | Offline race |
      | location | Offline city |
    And the race has a club "Offline club"
    And the race has series with attributes:
      | name | Offline series |
      | first_number | 15 |
      | start_time | 13:00 |
    And the series has an age group "Offline age group"
    And the race has correct estimates with attributes:
      | min_number | 15 |
      | max_number | 16 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Offline club |
    And the competitor belongs to an age group "Offline age group"
    And the series has a competitor with attributes:
      | first_name | Tim |
      | last_name | Smith |
      | club | Offline club |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:10:25 |
    And the competitor "Tim" "Smith" has the following results:
      | estimate1 | 109 |
      | estimate2 | 131 |
      | arrival_time | 13:58:11 |
    And the shots for the competitor "Tim" "Smith" are 10,10,9,9,9,8,7,6,5,0
    And the race is finished
    And I am on the official race page of "Offline race"
    And I follow "Julkaise"
    Then I should be on the publish race page of "Offline race"
    But I should not see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi."
    And I should see "Julkaistava kilpailu: Offline race"
    # hack for duplicate name-location-date problem in saving
    # the form has the old name (Offline race) but in the db there is no race with such name
    Given the race "Offline race" is renamed to "Original race"
    When I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I select "Integration test" from "Kohde"
    And I press "Julkaise"
    Then I should see "Kilpailun tiedot ladattu kohdejärjestelmään" within "div.success"
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - kilpailu julkaistu (test)" in the email subject
    And I should see "Julkaistu kilpailu: Offline race (Offline city)" in the email body
    And I should see "Toimitsija: Robert Onliner" in the email body
    Given I use the software online again
    And I am on the home page
    And I follow "Kirjaudu sisään"
    And I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I press "Kirjaudu"
    And I follow "Toimitsijan sivut"
    Then I should be on the official index page
    And I should see "Offline race"
    When I follow "Offline race"
    Then I should see "Offline series"
    But I should not see "kun kaikki tulokset on syötetty"
    When I follow "Kilpailu & sarjat"
    Then the "Paikkakunta" field should contain "Offline city"
    And the "Nimi" field should contain "Offline age group"
    When I follow "Seurat"
    Then I should see "Offline club"
    When I follow "Oikeat arviot"
    Then the "Lähtönumerot" field should contain "15"
    And the "race_correct_estimates_attributes_0_max_number" field should contain "16"
    And the "Etäisyys 1" field should contain "110"
    And the "Etäisyys 2" field should contain "130"
    When I follow "Kilpailijat & lähtölista"
    Then I should see "Johnson James"
    And I should see "(Offline age group)"
    And I should see "13:00:00"
    And I should see "15"
    And I should see "Offline club"
    When I follow "Johnson James"
    Then the "Ammunta yhteensä" field should contain "85"
    And the "Arvio 1" field should contain "111"
    And the "Arvio 2" field should contain "129"
    And the "competitor_arrival_time_4i" field should contain "14"
    And the "competitor_arrival_time_5i" field should contain "10"
    And the "competitor_arrival_time_6i" field should contain "25"
    When I follow "Kilpailijat & lähtölista"
    And I follow "Smith Tim"
    Then the "competitor_shots_attributes_0_value" field should contain "10"
    And the "competitor_shots_attributes_1_value" field should contain "10"
    And the "competitor_shots_attributes_2_value" field should contain "9"
    And the "competitor_shots_attributes_3_value" field should contain "9"
    And the "competitor_shots_attributes_4_value" field should contain "9"
    And the "competitor_shots_attributes_5_value" field should contain "8"
    And the "competitor_shots_attributes_6_value" field should contain "7"
    And the "competitor_shots_attributes_7_value" field should contain "6"
    And the "competitor_shots_attributes_8_value" field should contain "5"
    And the "competitor_shots_attributes_9_value" field should contain "0"

  Scenario: Try to publish with invalid account
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given I use the software offline
    And I have an ongoing race "Offline race"
    And the race has a club "Offline club"
    And the race has series with attributes:
      | name | Offline series |
      | first_number | 15 |
      | start_time | 13:00 |
    And the series has an age group "Offline age group"
    And the race has correct estimates with attributes:
      | min_number | 15 |
      | max_number | 16 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Offline club |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 14:10:25 |
    And the race is finished
    And I am on the official race page of "Offline race"
    And I follow "Julkaise"
    Then I should be on the publish race page of "Offline race"
    When I fill in "wrong@email.com" for "Sähköposti"
    And I fill in "wrong password" for "Salasana"
    And I select "Integration test" from "Kohde"
    And I press "Julkaise"
    And I should see "Virheelliset tunnukset" within "div.error"
