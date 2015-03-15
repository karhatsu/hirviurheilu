Feature: Export race
  In order to let the competitors and anyone who is interested to see the race results
  As a person using the software offline
  I want to publish the finished race to an online service

  Scenario: Unfinished race
    Given I use the software offline
    And I have an ongoing race "Offline race"
    And I am on the official race page of "Offline race"
    And I follow "Julkaise"
    Then I should see "Offline race" within "div.main_title"
    And the official main menu item should be selected
    And the "Julkaise" sub menu item should be selected
    And I should see "Julkaise kilpailu internetissä" within "h2"
    And I should see "Tällä sivulla voit julkaista kilpailun lopulliset tulokset internetissä, Hirviurheilu-palvelussa." in an info message
    And I should see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi." in an error message

  # In this scenario the race is exported to the same system which is relevant only for testing.
  # The first user in the scenario is automatically used in the offline state.
  # The second user is meant for receiving the uploaded race.
  Scenario: Export finished race from offline to online
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given there is an official "Robert" "Onliner" with email "online@hirviurheilu.com" and password "online"
    Given I use the software offline
    And I have an ongoing race with attributes:
      | name | Offline race |
      | location | Offline city |
      | home_page | www.test.com/offline_race |
    And the race has a club "Offline club" with long name "Long offline shooting club"
    And the race has series with attributes:
      | name | Offline series |
      | first_number | 15 |
      | start_time | 13:00 |
      | national_record | 1050 |
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
    And the race has a relay with attributes:
      | name | Offline relay |
      | legs_count | 2 |
      | start_time | 08:30 |
    And the relay has a team "Offline relay team" with number 1
    And the relay team has a competitor with attributes:
      | first_name | Harry |
      | last_name | Peterson |
      | leg | 1 |
      | arrival_time | 08:45:10 |
      | misses | 4 |
      | estimate | 123 |
      | adjustment | 50 |
    And the relay team has a competitor with attributes:
      | first_name | Mathew |
      | last_name | Stevens |
      | leg | 2 |
      | arrival_time | 09:01:12 |
      | misses | 0 |
      | estimate | 100 |
    And the relay has the correct estimates:
      | leg | distance |
      | 1 | 105 |
      | 2 | 88 |
    And the relay is finished
    And the race has a team competition "Ladies" with 8 competitors / team
    And the team competition contains the series "Offline series"
    And the team competition contains the age group "Offline age group"
    And the race has a team competition "Young men" with 9 competitors / team
    And I am on the official race page of "Offline race"
    And I follow "Julkaise"
    Then I should be on the export race page of "Offline race"
    But I should not see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi."
    But I should not see "Jos sinulla on Hirviurheilu Offline"
    And the "Kilpailun nimi" field should contain "Offline race"
    When I fill in "New name for race" for "Kilpailun nimi"
    And I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I select "Integration test" from "Kohde"
    And I press "Julkaise"
    Then I should see "Kilpailun tiedot ladattu kohdejärjestelmään" in a success message
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - kilpailu julkaistu (test)" in the email subject
    And I should see "Julkaistu kilpailu: New name for race (Offline city)" in the email body
    And I should see "Toimitsija: Robert Onliner" in the email body
    Given I use the software online again
    And I am on the home page
    And I follow "Kirjaudu sisään"
    And I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I press "Kirjaudu"
    And I follow "Toimitsijan sivut"
    Then I should be on the official index page
    When I follow "New name for race" within "#existing_races"
    Then I should see "Offline series"
    But I should not see "kun kaikki tulokset on syötetty"
    When I follow "Kilpailu & sarjat"
    Then the "Paikkakunta" field should contain "Offline city"
    And the "Linkki kilpailun kotisivuille" field should contain "www.test.com/offline_race"
    And the "Nimi" field should contain "Offline age group"
    And the "SE" field should contain "1050"
    When I follow "Seurat"
    Then I should see "Offline club"
    And I should see "Long offline shooting club"
    When I follow "Oikeat arviot"
    Then the "Lähtönumerot" field should contain "15"
    And the "race_correct_estimates_attributes_0_max_number" field should contain "16"
    And the "Etäisyys 1" field should contain "110"
    And the "Etäisyys 2" field should contain "130"
    When I follow "Kilpailijat"
    Then I should see "Johnson James"
    And I should see "(Offline age group)"
    And I should see "13:00:00"
    And I should see "15"
    And I should see "Offline club"
    When I follow "Johnson James"
    Then the "Ammunta yhteensä" field should contain "85"
    And the "Arvio 1" field should contain "111"
    And the "Arvio 2" field should contain "129"
    And the "Saapumisaika" field should contain "14:10:25"
    When I follow "Kilpailijat"
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
    When I follow "Viestit"
    Then I should see "Offline relay"
    And I should see "08:30"
    And I should see /1/ within "td.teams_count"
    But I should not see "Päätä tämä viesti"
    When I choose "Offline relay" from third level menu
    Then the "relay_relay_correct_estimates_attributes_0_distance" field should contain "105"
    And the "relay_relay_correct_estimates_attributes_1_distance" field should contain "88"
    And the "Joukkueen nimi" field should contain "Offline relay team"
    And there should be editable relay competitor "Harry" "Peterson" with 4 misses and estimate 123
    And I should see "08:45:10"
    And I should see "50"
    When I follow "Joukkuek."
    Then I should see "Ladies"
    And I should see "8"
    And I should see "Offline series, Offline age group"
    Then I should see "Young men"
    And I should see "9"

  Scenario: Try to export with invalid account
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given I use the software offline
    And I have a complete race "Offline race" located in "Offline city"
    And I am on the export race page of "Offline race"
    When I fill in "wrong@email.com" for "Sähköposti"
    And I fill in "wrong password" for "Salasana"
    And I select "Integration test" from "Kohde"
    And I press "Julkaise"
    Then I should see "Virheelliset tunnukset" in an error message

  Scenario: Try to export same race twice without renaming the race
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given I use the software offline
    And I have a complete race "Offline race" located in "Offline city"
    And I am on the export race page of "Offline race"
    When I fill in "offline@hirviurheilu.com" for "Sähköposti"
    And I fill in "offline" for "Salasana"
    And I select "Integration test" from "Kohde"
    And I press "Julkaise"
    Then I should see "Järjestelmästä löytyy jo kilpailu, jolla on sama nimi, sijainti ja päivämäärä" in an error message

  # In this scenario the race is exported to the same system which is relevant only for testing.
  # The first user in the scenario is automatically used in the offline state.
  # The second user is meant for receiving the uploaded race.
  Scenario: Export race from online to offline
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given I am an official with email "online@hirviurheilu.com" and password "online"
    And I have a race "Online race"
    And the race has series "Online series"
    And I have logged in
    And I am on the official race page of "Online race"
    And I follow "Lataa"
    Then I should be on the export race page of "Online race"
    But I should not see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi."
    And I should not see "Kohde"
    And I should not see "Sähköposti"
    And I should not see "Salasana"
    And the "Kilpailun nimi" field should contain "Online race"
    When I fill in "Downloaded race" for "Kilpailun nimi"
    And I press "Lataa"
    Then I should see "Kilpailun tiedot ladattu omalle koneellesi" in a success message
    But the admin should receive no email
    Given I use the software offline
    When I follow "Toimitsijan sivut"
    Then I should be on the official index page
    When I follow "Downloaded race"
    Then I should see "Online series"
