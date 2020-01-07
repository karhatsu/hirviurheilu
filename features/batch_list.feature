Feature: Batch list
  In order to know when I am about to shoot
  As a competitor
  I want to see the batch list

  Scenario: No batches defined
    Given there is a race with attributes:
      | sport_key | AIR |
    And the race has series "M"
    And the series has a competitor "Teppo" "Testinen"
    And I am on the race page
    Then I should not see "Lähtölista"
    When I follow "Eräluettelo"
    Then I should be on the race batch list page
    And the "Kilpailut" main menu item should be selected
    And the "Eräluettelo" sub menu item should be selected
    And I should see "Eräluettelo" within "h2"
    And I should see "Kilpailun eräluetteloa ei ole vielä tehty" in an info message
