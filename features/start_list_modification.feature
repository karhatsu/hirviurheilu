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

  @javascript
  Scenario: When no series that have start list, show instructions
    Given I am an official
    And I have a race "Test race"
    And the race has series "M60"
    And the series has a competitor with attributes:
      | first_name | Matti |
      | last_name | Miettinen |
    And I have logged in
    When I go to the official start list page of the race "Test race"
    Then I should see "Yhdellekään sarjalle ei ole luotu vielä lähtölistaa"
    But I should not see "Matti"

  @javascript
  Scenario: Show only competitors who have start times
    Given I am an official
    And I have a race "Test race"
    And the race has series "M60"
    And the series has a competitor with attributes:
      | first_name | Matti |
      | last_name | Miettinen |
    And the race has series with attributes:
      | name | M |
      | start_time | 01:25 |
      | first_number | 50 |
    And the series has a competitor with attributes:
      | first_name | Timo |
      | last_name | Turunen |
    And the start list has been generated for the series
    And I have logged in
    And I am on the official race page of "Test race"
    When I choose "Lähtöajat" from sub menu
    Then I should be on the official start list page of the race "Test race"
    And the official main menu item should be selected
    And the "Lähtöajat" sub menu item should be selected
    And I should see "Lähtöajat" within "h2"
    # fields 1-5: new competitor
    And the input field 6 value should be "50"
    And the input field 7 value should be "01:25:00"
    And the input field 8 value should be "Timo"
    And the input field 9 value should be "Turunen"
    But I should not see "Matti"
    And I should not see "Miettinen"
