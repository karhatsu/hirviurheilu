Feature: Start list modification
  In order to react changing needs before the race
  As an official
  I want to change start list positions between competitors
  
  Scenario: When no series, don't show the start list modification tab
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And I am on the official race page of "Test race"
    Then I should not see "Lähtöajat"
  
  Scenario: Go to the start list modification page
    Given I am an official
    And I have a race "Test race"
    And the race has series "M"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Lähtöajat"
    Then I should be on the official start list page of the race "Test race"
    Then the official main menu item should be selected
    And the "Lähtöajat" sub menu item should be selected
    And I should see "Kaikkien kilpailijoiden lähtöajat" within "h2"

  Scenario: Show only competitors who have start times
    Given I am an official
    And I have a race "Test race"
    And the race has series "M60"
    And the series has a competitor with attributes:
      | first_name | Matti |
      | last_name | Miettinen |
    And the race has series with attributes:
      | name | M |
      | start_time | 13:00 |
      | first_number | 50 |
    And the series has a competitor with attributes:
      | first_name | Timo |
      | last_name | Turunen |
    And the start list has been generated for the series
    And I have logged in
    When I go to the official start list page of the race "Test race"
    Then I should see "50"
    And I should see "13:00:00"
    And I should see "Timo"
    And I should see "Turunen"
    But I should not see "Matti"
    And I should not see "Miettinen"
