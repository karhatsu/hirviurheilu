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
    When I follow "Lisää tämän sarjan ensimmäinen kilpailija"
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Kilpailijat" sub menu item should be selected
    When I select "M60" from "Sarja"
    And I select "M70" from "Ikäryhmä"
    And I fill in "Matti" for "Etunimi"
    And I fill in "Myöhänen" for "Sukunimi"
    And I fill in "Testiseura" for "club_name"
    And I press "Tallenna"
    Then I should see "Kilpailija lisätty" in a success message
    And I should see "Myöhänen Matti, Testiseura (M60/M70)"
