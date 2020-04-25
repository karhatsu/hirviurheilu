Feature: Finish race
  In order to be able to show the correct estimates for the competitors
  As an official
  I want to finish the race

  Scenario: No series defined for the race
    Given I am an official
    And I have an ongoing race "Test race"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "kun kaikki tulokset on syötetty"

  Scenario: No competitors defined for the race
    Given I am an official
    And I have an ongoing race "Test race"
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "kun kaikki tulokset on syötetty"

  Scenario: The race is in the future
    Given I am an official
    And I have a future race "Test race"
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "kun kaikki tulokset on syötetty"

  Scenario: Competitors are missing correct estimates
    Given I am an official
    And I have an ongoing race "Test race"
    And the race has series "Test series"
    And the series has a competitor
    And I have logged in
    When I go to the official race page of "Test race"
    And I follow "Kilpailun päättäminen"
    Then I should see "Kilpailu pitää merkitä päättyneeksi, jotta kilpailijat näkevät, että kaikkien tulokset on merkitty " in an info message
    When I press "Merkitse yksilökilpailut päättyneeksi"
    Then I should see "Osalta kilpailijoista puuttuu oikea arviomatka" in an error message

  Scenario: Competitors are missing results
    Given I am an official
    And I have an ongoing race "Test race"
    And the race has series with attributes:
      | name | Test series |
      | start_time | 01:00 |
      | first_number | 1 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 1 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And the start list has been generated for the series
    And I have logged in
    When I go to the official race page of "Test race"
    And I follow "Kilpailun päättäminen"
    And I press "Merkitse yksilökilpailut päättyneeksi"
    Then I should see "Kaikilla kilpailjoilla ei ole tulosta" in an error message
    When I choose "DNF" for the competitor on finish race
    And I press "Merkitse yksilökilpailut päättyneeksi"
    Then I should see "Kilpailu Test race on merkitty päättyneeksi" in a success message
    When I follow the first "Kilpailijat" link
    Then I should see "DNF"

  Scenario: Finish race successfully
    Given I am an official "Timo Toimitsija" with email "timo@test.com"
    And I have an ongoing race "Test race"
    And the race has series with attributes:
      | name | Test series |
      | start_time | 01:00 |
      | first_number | 1 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 2 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And the series has a competitor with attributes:
      | first_name | Lary |
      | last_name | Late |
      | no_result_reason | DNS |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shooting_score_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 02:00:10 |
    And the race has series "Empty series to be deleted automatically"
    And I have logged in
    When I go to the official race page of "Test race"
    And I follow "Kilpailun päättäminen"
    And I press "Merkitse yksilökilpailut päättyneeksi"
    Then I should be on the official race page of "Test race"
    And I should see "Kilpailu Test race on merkitty päättyneeksi" in a success message
    And I should see "Test series"
    But I should not see "Empty series to be deleted automatically"
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - kilpailu päättynyt (test)" in the email subject
    And I should see "Kilpailun nimi: Test race" in the email body
    And I should see "Kilpailijoiden määrä: 2" in the email body
    And I should see "Maaliin tulleiden kilpailijoiden määrä: 1" in the email body
    And I should see "Toimitsija: Timo Toimitsija (timo@test.com)" in the email body
    When I click the first link in the email
    Then I should be on the race page of "Test race"

  Scenario: Finish single series
    Given I am an official
    And I have a "ILMAHIRVI" race "Ilmakisa"
    And the race has series "Series 1"
    And the series has a competitor with shots "9,9,9,9,9,9,9,9,9,9"
    And the race has series "Series 2"
    And the series has a competitor with shots "9,9,9,9,9,9,9,9,9,9"
    And I have logged in
    And I am on the official race page of "Ilmakisa"
    When I follow the first "Päätä sarja" link
    And I select "Series 2" from "Päätettävä sarja"
    And I press "Merkitse yksilökilpailut päättyneeksi"
    Then I should see "Sarja Series 2 on merkitty päättyneeksi" in a success message
    And series "Series 2" should be finished
    But series "Series 1" should not be finished
    And the race should not be finished
    When I select "Koko kilpailu" from "Päätettävä sarja"
    And I press "Merkitse yksilökilpailut päättyneeksi"
    Then I should be on the official race page of "Ilmakisa"
    And I should see "Kilpailu Ilmakisa on merkitty päättyneeksi" in a success message
    And series "Series 1" should be finished
