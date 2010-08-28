Feature: Main page
  In order to start using the service
  As a user
  I want to access the service main page

  Scenario: Load main page
    Given I go to the home page
    Then I should see "Hirvenhiihdon ja hirvenjuoksun tulospalvelu" within "h1"

  Scenario: Listing races in the main page
    Given there is a race with attributes:
      | name | Old race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Old city |
    And there is a race with attributes:
      | name | Upcoming race |
      | start_date | 2020-01-01 |
      | end_date | 2020-01-02 |
      | location | Upcoming city |
    And there is an ongoing race with attributes:
      | name | Ongoing race |
      | location | Ongoing city |
    And I go to the home page
    Then I should see "Päättyneet kilpailut" within "div.old_races"
    And I should see "Old race" within "div.old_races"
    And I should see "01.01.2010 - 02.01.2010, Old city" within "div.old_races"
    And I should see "Tulevat kilpailut" within "div.future_races"
    And I should see "Upcoming race" within "div.future_races"
    And I should see "01.01.2020 - 02.01.2020, Upcoming city" within "div.future_races"
    And I should see "Menossa olevat kilpailut" within "div.ongoing_races"
    And I should see "Ongoing race" within "div.ongoing_races"
    And I should see "Ongoing city" within "div.ongoing_races"
