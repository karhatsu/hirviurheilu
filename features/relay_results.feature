Feature: Relay results
  In order to know what teams were the best in relay
  As a user
  I want to see the relay results

  Scenario: No relays for the race
    Given there is a race "Relay race"
    And I am on the race page of "Relay race"
    Then I should not see "Viestit"

  Scenario: No teams for a relay
    Given there is a race "Relay race"
    And the race has a relay "Women's relay"
    When I go to the relay results page of "Women's relay"
    Then the "Kilpailut" main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should see "Women's relay - (Ei joukkueita)" within "h2"
    And I should see "Viestiin ei ole vielä merkitty joukkueita" in an info message
    
  Scenario: The relay has teams but no start time defined
    Given there is a race "Relay race"
    And the race has a relay "Women's relay"
    When I go to the relay results page of "Women's relay"
    And the relay has a team "Relay team"
    When I go to the relay results page of "Women's relay"
    Then I should see "Women's relay - (Viesti ei ole vielä alkanut)" within "h2"
    And I should see "Viestin lähtöaikaa ei ole vielä päätetty" in an info message

  Scenario: The relay has not started yet
    Given there is a race "My race" in the future
    And the race has a relay with attributes:
      | name | Women's relay |
      | start_time | 16:30 |
      | legs_count | 2 |
    And the relay has a team "Ladies team" with number 1
    And the relay team has a competitor with attributes:
      | first_name | Mary |
      | last_name | Smith |
      | leg | 1 |
    And the relay team has a competitor with attributes:
      | first_name | Tina |
      | last_name | Smith |
      | leg | 2 |
    And the relay has a team "Relay team"
    When I go to the relay results page of "Women's relay"
    Then I should see "Women's relay - (Viesti ei ole vielä alkanut)" within "h2"
    And I should see "Viestin lähtöaika" in an info message
    And I should see "Viestin alkuun on aikaa" in an info message
    And I should see "Ladies team"
    And I should see "Smith Mary"

  Scenario: Relay results
    Given there is a race with attributes:
      | name | Relay race |
      | start_date | 2011-01-15 |
    And the race has a relay "Women's relay"
    And the race has a relay with attributes:
      | name | Men's relay |
      | legs_count | 3 |
      | start_time | 12:00 |
    And the relay has the correct estimates:
      | leg | distance |
      | 1 | 105 |
      | 2 | 88 |
    And the relay has a team "Green team" with number 1
    And the relay team has a competitor with attributes:
      | first_name | TimG |
      | last_name | SmithG |
      | leg | 1 |
      | arrival_time | 00:15:10 |
      | misses | 0 |
      | estimate | 123 |
    And the relay team has a competitor with attributes:
      | first_name | JohnG |
      | last_name | StevensonG |
      | leg | 2 |
      | arrival_time | 00:31:12 |
      | misses | 0 |
      | estimate | 100 |
    And the relay team has a competitor with attributes:
      | first_name | GaryG |
      | last_name | JohnsonG |
      | leg | 3 |
      | arrival_time | 00:44:54 |
      | misses | 0 |
      | estimate | 100 |
    And the relay has a team "Yellow team" with number 2
    And the relay team has a competitor with attributes:
      | first_name | TimY |
      | last_name | SmithY |
      | leg | 1 |
      | arrival_time | 00:15:05 |
      | misses | 0 |
      | estimate | 100 |
    And the relay team has a competitor with attributes:
      | first_name | JohnY |
      | last_name | StevensonY |
      | leg | 2 |
      | arrival_time | 00:32:12 |
      | misses | 0 |
      | estimate | 100 |
    And the relay team has a competitor with attributes:
      | first_name | GaryY |
      | last_name | JohnsonY |
      | leg | 3 |
      | arrival_time | 00:43:13 |
      | misses | 0 |
      | estimate | 100 |
    And the relay has a team "Red team" with number 3
    And the relay team has a competitor with attributes:
      | first_name | TimR |
      | last_name | SmithR |
      | leg | 1 |
      | arrival_time | 00:15:06 |
      | misses | 0 |
      | estimate | 100 |
    And the relay team has a competitor with attributes:
      | first_name | JohnR |
      | last_name | StevensonR |
      | leg | 2 |
      | arrival_time | 00:35:12 |
      | misses | 0 |
      | estimate | 100 |
    And the relay team has a competitor with attributes:
      | first_name | GaryR |
      | last_name | JohnsonR |
      | leg | 3 |
      | arrival_time | 00:43:12 |
      | misses | 0 |
      | estimate | 100 |
    Given I am on the home page
    When I follow "Relay race"
    Then I should see /Viestit/ within "h2"
    And I should see "Men's relay"
    And I should see "12:00"
    When I follow "Men's relay"
    Then I should be on the relay results page of "Men's relay"
    And the "Viestit" sub menu item should be selected
    And I should see "Men's relay - Tilanne" within "h2"
    And I should see "Kilpailu on kesken. Tarkemmat arviointitiedot julkaistaan, kun kilpailu on päättynyt." in an info message
    But I should not see "Oikeat etäisyydet"
    And I should see "1." within "tr#team_1"
    And I should see "Red team" within "tr#team_1"
    And I should see "43:12" within "tr#team_1"
    And I should see "2." within "tr#team_2"
    And I should see "Yellow team" within "tr#team_2"
    And I should see "43:13" within "tr#team_2"
    And I should see "3." within "tr#team_3"
    And I should see "Green team" within "tr#team_3"
    And I should see "44:54" within "tr#team_3"
    But I should not see "123m"
    Given the relay is finished
    And I am on on the relay results page of "Men's relay"
    Then I should see "Men's relay - Tulokset"
    But I should not see "Kilpailu on kesken"
    But I should see "Oikeat etäisyydet" within "h3"
    And I should see "Osuus 1: 105 m"
    And I should see "Osuus 2: 88 m"
    And I should see "123m"
    When I follow "Osuus 2"
    Then I should see "Men's relay - Osuus 2" within "h2"
    And I should see "1." within "tr#team_1"
    And I should see "Green team" within "tr#team_1"
    And I should see "StevensonG JohnG" within "tr#team_1"
    And I should see "31:12" within "tr#team_1"
    And I should see "2." within "tr#team_2"
    And I should see "Yellow team" within "tr#team_2"
    And I should see "StevensonY JohnY" within "tr#team_2"
    And I should see "32:12" within "tr#team_2"
    And I should see "3." within "tr#team_3"
    And I should see "Red team" within "tr#team_3"
    And I should see "StevensonR JohnR" within "tr#team_3"
    And I should see "35:12" within "tr#team_3"
    When I follow "Maali"
    Then I should be on the relay results page of "Men's relay"
    When I follow "Women's relay"
    Then I should be on the relay results page of "Women's relay"
    When I follow "Takaisin sivulle Relay race"
    Then I should be on the race page of "Relay race"
