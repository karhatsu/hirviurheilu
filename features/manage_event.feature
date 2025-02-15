Feature: Manage event
  In order to group races into an event
  As an official
  I want to add and modify events

  @javascript
  Scenario: Not enough own races
    Given there is a race "Not my race" in the future
    And I am an official
    And I have a future race "Only one race"
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi tapahtuma"
    Then I should be on the new official event page
    And the official main menu item should be selected
    And the page title should contain "Uusi tapahtuma"
    And I should see "Sinulla pitää olla vähintään kaksi kilpailua, jotta voit luoda tapahtuman" in an info message

  @javascript
  Scenario: Add and edit event
    Given I am an official
    And I have a future race "My race 1"
    And I have a future race "My race 2"
    And I have a future race "My race 3"
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi tapahtuma"
    Then I should not see "Sinulla pitää olla vähintään kaksi kilpailua"
    When I check "race_1"
    And I check "race_3"
    And I fill in "My event" for "Nimi"
    And I press "Tallenna"
    Then the page title should contain "My event"
    And I should see "My race 1"
    And I should see "My race 3"
    But I should not see "My race 2"
    When I follow "Muokkaa tapahtumaa"
    And I fill in "Changed event name" for "Nimi"
    And I press "Tallenna"
    Then the page title should contain "Changed event name"
