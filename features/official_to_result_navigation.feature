Feature: Navigation between official and result sections
  In order to save some clicks
  As an official
  I want to navigate easily and fast between official and result sections

  Scenario: Click races tab in main page
    Given there is a race with attributes:
      | name | Run race |
      | location | Running place |
      | start_date | 2010-08-18 |
    And there is a race with attributes:
      | name | Ski race |
      | location | Skiing place |
      | start_date | 2011-02-11 |
    And there is a race with attributes:
      | name | Third test race |
      | location | Test location |
      | start_date | 2011-01-09 |
      | end_date | 2011-01-10 |
    And I am on the home page
    When I follow "Kilpailut" within "div.menu"
    Then I should be on the races page
    And the "Kilpailut" main menu item should be selected
    And I should see "Hirviurheilu - Kilpailut" within ".main_title"
    And I should see "Run race, 18.08.2010, Running place"
    And I should see "Third test race, 09.01.2011 - 10.01.2011, Test location"
    And I should see "Ski race, 11.02.2011, Skiing place"
    When I follow "Ski race"
    Then I should be on the race page of "Ski race"

  Scenario: Quick navigation between result pages and official pages
    Given I am an official
    And I have a race "My race"
    And the race has series "My series"
    And I have logged in
    And I am on the race page
    When I follow "My race" within "div.menu"
    Then I should be on the official race page of "My race"
    When I follow "Kilpailijat"
    Then I should be on the official competitors page of the series
    When I follow "My race" within "div.menu"
    Then I should be on the race page
    When I follow "Tulokset"
    Then I should be on the results page of the series
    When I follow "My race" within "div.menu"
    Then I should be on the official race page of "My race"

  Scenario: No quick navigation when not logged in
    Given I am an official
    And I have a race "My race"
    And I am on the race page
    Then I should not see "My race" within "div.menu"

  Scenario: No quick navigation when not own race
    Given I am an official
    And I have logged in
    And I have a race "My race"
    And there is a race "Another race"
    And I am on the race page
    Then I should not see "Another race" within "div.menu"

  Scenario: (Offline) user is instructed to add race when in the competitions page without competitions
    Given I use the software offline
    When I go to the home page
    And I follow "Kilpailut"
    Then I should see "Et ole lisännyt vielä yhtään kilpailua" within "div.info"
    When I follow "Lisää kilpailu"
    Then I should be on the new race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
    And I press "Lisää kilpailu"
    Then I should see "Kilpailu lisätty"
    When I go to the home page
    And I follow "Kilpailut"
    Then I should not see "Et ole lisännyt vielä yhtään kilpailua"
