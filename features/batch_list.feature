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

  Scenario: Race with batches
    Given there is a race with attributes:
      | sport_key | AIR |
    And the race has a club "Testiseura"
    And the race has a batch 1 with track 1 and time "10:00"
    And the race has a batch 2 with track 2 and time "10:30"
    And the race has series "M"
    And the series has a competitor with attributes:
      | first_name  | Teppo      |
      | last_name   | Testaaja   |
      | club        | Testiseura |
      | number      | 5          |
      | batch       | 1          |
      | track_place | 10         |
    And the series has a competitor with attributes:
      | first_name  | Timo       |
      | last_name   | Testaaja   |
      | club        | Testiseura |
      | number      | 6          |
      | batch       | 1          |
      | track_place | 11         |
    And the race has series "N"
    And the series has a competitor with attributes:
      | first_name  | Tyyne      |
      | last_name   | Testinen   |
      | club        | Testiseura |
      | number      | 7          |
      | batch       | 2          |
      | track_place | 5          |
    And I am on the race page
    Then I should see "Eräluettelo (PDF)"
    But I should not see "Kaikkien sarjojen lähtöajat (PDF)"
    When I follow "Eräluettelo"
    Then I should see batch 1 on track 1 with time "10:00"
    And I should see batch 2 on track 2 with time "10:30"
    And the batch 1 should contain a competitor "10. Testaaja Teppo (5), Testiseura (M)" in row 1
    And the batch 1 should contain a competitor "11. Testaaja Timo (6), Testiseura (M)" in row 2
    And the batch 2 should contain a competitor "5. Testinen Tyyne (7), Testiseura (N)" in row 1
