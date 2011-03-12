Feature: Relay results
  In order to know what teams were the best in relay
  As a user
  I want to see the relay results

  Scenario: No relays for the race
    Given there is a race "Relay race"
    And I am on the race page of "Relay race"
    Then I should not see "Viestit"

  Scenario: Relay results
    Given there is a race "Relay race"
    And the race has a relay "Women's relay"
    And the race has a relay with attributes:
      | name | Men's relay |
      | legs_count | 3 |
      | start_time | 12:00 |
    And the relay has a team "Green team" with number 1
    And the relay team has a competitor with attributes:
      | first_name | TimG |
      | last_name | SmithG |
      | leg | 1 |
      | arrival_time | 12:15:10 |
    And the relay team has a competitor with attributes:
      | first_name | JohnG |
      | last_name | StevensonG |
      | leg | 2 |
      | arrival_time | 12:31:12 |
    And the relay team has a competitor with attributes:
      | first_name | GaryG |
      | last_name | JohnsonG |
      | leg | 3 |
      | arrival_time | 12:44:54 |
    And the relay has a team "Yellow team" with number 2
    And the relay team has a competitor with attributes:
      | first_name | TimY |
      | last_name | SmithY |
      | leg | 1 |
      | arrival_time | 12:15:05 |
    And the relay team has a competitor with attributes:
      | first_name | JohnY |
      | last_name | StevensonY |
      | leg | 2 |
      | arrival_time | 12:32:12 |
    And the relay team has a competitor with attributes:
      | first_name | GaryY |
      | last_name | JohnsonY |
      | leg | 3 |
      | arrival_time | 12:43:13 |
    And the relay has a team "Red team" with number 3
    And the relay team has a competitor with attributes:
      | first_name | TimR |
      | last_name | SmithR |
      | leg | 1 |
      | arrival_time | 12:15:06 |
    And the relay team has a competitor with attributes:
      | first_name | JohnR |
      | last_name | StevensonR |
      | leg | 2 |
      | arrival_time | 12:35:12 |
    And the relay team has a competitor with attributes:
      | first_name | GaryR |
      | last_name | JohnsonR |
      | leg | 3 |
      | arrival_time | 12:43:12 |
    Given I am on the home page
    When I follow "Relay race"
    Then I should see "Viestit" within "h2"
    And I should see "Men's relay"
    And I should see "12:00"
    When I follow "Men's relay"
    Then I should be on the relay results page of "Men's relay"
    And the "Viestit" sub menu item should be selected
    And I should see "Men's relay - Tulokset" within "h2"
    And I should see "1." within "tr#team_1"
    And I should see "Red team" within "tr#team_1"
    And I should see "43:12" within "tr#team_1"
    And I should see "2." within "tr#team_2"
    And I should see "Yellow team" within "tr#team_2"
    And I should see "43:13" within "tr#team_2"
    And I should see "3." within "tr#team_3"
    And I should see "Green team" within "tr#team_3"
    And I should see "44:54" within "tr#team_3"
    When I follow "Women's relay"
    Then I should be on the relay results page of "Women's relay"
    When I follow "Takaisin kilpailun etusivulle"
    Then I should be on the race page of "Relay race"
