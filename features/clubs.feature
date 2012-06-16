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
    And the official main menu item should be selected
    And the "Seurat" sub menu item should be selected
    And I should see "Seurat" within "h2"
    And I should see "First club"
    And I should see "Another club"
    
  @javascript
  Scenario: Add and remove a club
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And I am on the official clubs page for "Test race"
    When I fill in "New club" for "Nimi"
    And I press "Lisää seura"
    Then I should see "New club"
    When I press "Poista"
    Then I should not see "Test club"
    