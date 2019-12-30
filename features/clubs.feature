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
    And I should see "First club"
    And I should see "Another club"

  @javascript
  Scenario: Add, rename and remove a club
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And I am on the official clubs page for "Test race"
    When I follow "Lisää seura"
    And I fill in "New club" for "Nimi"
    And I press "Tallenna"
    Then I should see "New club"
    When I follow "Muokkaa"
    And I fill in "Renamed club" for "Nimi"
    And I press "Tallenna"
    Then I should see "Renamed club"
    But I should not see "New club"
    When I follow "Poista"
    Then I should not see "Renamed club"
