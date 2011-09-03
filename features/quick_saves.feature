Feature: Quick result save
  In order to save time and bandwidth
  As an official
  I want to save individual results quickly wit Quick save

  Scenario: Go to quick save page
    Given I am an official
    And I have a race "Relay race"
    And the race has series "M"
    And the series has a competitor
    And I have logged in
    And I am on the official race page of "Relay race"
    When I follow "Pikasyöttö"
    Then the official main menu item should be selected
    And the "Pikasyöttö" sub menu item should be selected
    And I should see "Tulosten pikasyöttö"
