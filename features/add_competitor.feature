Feature: Add competitor
  In order to save results for competitors
  As an official
  I want to add competitors

  @javascript
  Scenario: Add competitor when competitors' start order is mainly by series
    Given I am an official
    And I have a race "Test race"
    And the race has series "M"
    And the race has series "M60"
    And the series has an age group "M65"
    And the series has an age group "M70"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow the first "Lisää 1. kilpailija" link
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Kilpailijat" sub menu item should be selected
    And I should not see "Numero"
    When I select "M60" from "Sarja"
    And I select "M70" from "Ikäryhmä"
    And I fill in "Matti" for "Etunimi"
    And I fill in "Myöhänen" for "Sukunimi"
    And I fill in "Testiseura" for "competitor_new_clubName"
    And I press "Tallenna"
    Then I should see "Myöhänen Matti (M60)"

  @javascript
  Scenario: Add competitor when competitors' start order is mixed
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_order | 2 |
    And the race has series "M"
    And the race has series "M60"
    And the series has an age group "M65"
    And the series has an age group "M70"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow the first "Lisää 1. kilpailija" link
    And the "Toimitsijan sivut" main menu item should be selected
    And the "Lähtöajat" sub menu item should be selected
    And I should be on the official start list page of the race "Test race"
    When I fill in "00:00:00" for "competitor_new_startTime"
    And I fill in "Matti" for "competitor_new_firstName"
    And I fill in "Myöhänen" for "competitor_new_lastName"
    And I fill in "Testiseura" for "competitor_new_clubName"
    And I select "M60" from "competitor_new_seriesId"
    And I select "M70" from "competitor_new_ageGroupId"
    And I click button "Lisää uusi" with id "competitor_new_save"
    Then I should see "Lisätty"
    And the "competitor_new_number" text field value should be "2"
    And the "competitor_new_startTime" text field value should be "00:01:00"
    And the "competitor_new_firstName" text field value should be ""
    And the "competitor_new_lastName" text field value should be ""
    And the "competitor_new_clubName" text field value should be ""

  @javascript
  Scenario: Add shooting competitor
    Given I am an official
    And I have a "ILMAHIRVI" race "Ilmakisa"
    And the race has series "M"
    And I have logged in
    And I am on the official race page of "Ilmakisa"
    When I follow the first "Lisää 1. kilpailija" link
    And I fill in "Matti" for "Etunimi"
    And I fill in "Myöhänen" for "Sukunimi"
    And I fill in "Testiseura" for "competitor_new_clubName"
    And I fill in "5" for "Numero"
    And I press "Tallenna"
    Then I should see "Myöhänen Matti (M)"
