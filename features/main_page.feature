Feature: Main page
  In order to start using the service
  As a user
  I want to access the service main page

  Scenario: Load main page
    Given I go to the home page
    Then the page title should contain "Tulospalvelu Metsästäjäliiton urheilulajeille"
    And the "Etusivu" main menu item should be selected

  Scenario: Listing races in the main page
    Given there is a race with attributes:
      | name | Old race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Old city |
    And there is a race with attributes:
      | name | Upcoming race |
      | start_date | 2030-01-01 |
      | end_date | 2030-01-02 |
      | location | Upcoming city |
    And there is an ongoing race with attributes:
      | name | Ongoing race |
      | location | Ongoing city |
    And I go to the home page
    Then I should see "Viimeksi päättyneet kilpailut"
    And I should see "Old race" within "div#past-races"
    And I should see "01.01.2010 - 02.01.2010, Old city" within "div#past-races"
    And I should see "Kilpailuja tulossa myöhemmin" within "div#future_races"
    And I should see "Upcoming race" within "div#future_races"
    And I should see "01.01.2030 - 02.01.2030, Upcoming city" within "div#future_races"
    And I should see "Kilpailut tänään"
    And I should see "Ongoing race" within "div#races_today"
    And I should see "Ongoing city" within "div#races_today"

  Scenario: Limiting races by district
    Given there is a district "Southern District"
    And there is a finished race "Finished southern race" for the district
    And there is an ongoing race "Ongoing southern race" for the district
    And there is a district "Northern District"
    And there is a finished race "Finished northern race" for the district
    And there is a future race "Future northern race" for the district
    And I am on the home page
    When I select "Southern District" from "district_id"
    And I press "Valitse"
    Then I should see "Finished southern race" within "div#past-races"
    And I should see "Ongoing southern race" within "div#races_today"
    But I should not see "Finished northern race" within "div#past-races"
    And I should not see "Future northern race" within "div#past-races"
    When I select "Kaikki piirit" from "district_id"
    And I press "Valitse"
    Then I should see "Finished southern race" within "div#past-races"
    And I should see "Finished northern race" within "div#past-races"

  Scenario: No races
    Given I go to the home page
    Then I should see "Tulevat kilpailut" within "div#future_races"
    And I should see "Tällä hetkellä ei tiedossa tulevia kilpailuita" within "div#future_races"
    And I should not see "Ei kilpailuita tänään"
    And I should not see "Päättyneet kilpailut"

  Scenario: Showing registration link for unauthenticated users
    Given I am on the home page
    When I choose "Aloita käyttö" from main menu
    Then I should be on the registration page

  Scenario: No registration link for authenticated users
    Given I am an official
    And I have logged in
    And I am on the home page
    Then I should not see "Aloita käyttö"
