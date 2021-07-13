Feature: Race navigation
  In order to get quickly from race to race
  As a user
  I want to use races dropdown menu

  Scenario: Change race
    Given there is a race "Today's race" today
    And there is a race "Next week's race" that starts in 2 days
    And there is a race "Not too old race" that was 2 days ago
    And there is a race "Too old race" that was 3 days ago
    And I am on the race page of "Today's race"
    Then the races main menu item should contain "Next week's race"
    And the races main menu item should contain "Today's race"
    And the races main menu item should contain "Not too old race"
    But the races main menu item should not contain "Too old race"
    When I choose "Next week's race" from main menu
    Then I should be on the race page of "Next week's race"
    When I choose "- Kaikki kilpailut -" from main menu
    Then I should be on the races page
