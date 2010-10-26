Feature: Clubs
  In order to add new clubs for my race, change existing clubs or remove useless ones
  As an official
  I need to manage clubs

  Scenario: Show clubs
    Given I am an official
    And I have a race "Test race"
    And the race has a club "First club"
    And the race has a club "Another club"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Seurat"
    Then I should be on the official clubs page for "Test race"
    And I should see "Seurat" within "h2"
    And I should see "First club"
    And I should see "Another club"
