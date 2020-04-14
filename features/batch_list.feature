Feature: Batch list
  In order to know when I am about to shoot
  As a competitor
  I want to see the batch list

  Scenario: No batches defined
    Given there is a "ILMAHIRVI" race "No batches race"
    And the race has series "M"
    And the series has a competitor "Teppo" "Testinen"
    And I am on the race page
    Then I should not see "Lähtölista"
    And I should not see "Alkukilpailun eräluettelot" within ".menu--sub"
    And I should not see "Loppukilpailun eräluettelot" within ".menu--sub"
    Then I go to the race qualification round batches page
    And I should see "Alkukilpailun eräluettelo" within "h2"
    And I should see "Kilpailun eräluetteloa ei ole tehty" in an info message
    Then I go to the race final round batches page
    And I should see "Loppukilpailun eräluettelo" within "h2"
    And I should see "Kilpailun eräluetteloa ei ole tehty" in an info message

  Scenario: Race with batches
    Given there is a "ILMALUODIKKO" race "Batches race"
    And the race has a club "Testiseura"
    And the race has a qualification round batch 1 with track 1 and time "10:00"
    And the race has a qualification round batch 2 with track 2 and time "10:30"
    And the race has a final round batch 1 with track 1 and time "11:00"
    And the race has series "M"
    And the series has a competitor with attributes:
      | first_name  | Teppo      |
      | last_name   | Testaaja   |
      | club        | Testiseura |
      | number      | 5          |
      | qualification_round_batch       | 1  |
      | qualification_round_track_place | 10 |
      | final_round_batch       | 1  |
      | final_round_track_place | 5 |
    And the series has a competitor with attributes:
      | first_name  | Timo       |
      | last_name   | Testaaja   |
      | club        | Testiseura |
      | number      | 6          |
      | qualification_round_batch       | 1  |
      | qualification_round_track_place | 11 |
      | final_round_batch       | 1  |
      | final_round_track_place | 4 |
    And the race has series "N"
    And the series has a competitor with attributes:
      | first_name  | Tyyne      |
      | last_name   | Testinen   |
      | club        | Testiseura |
      | number      | 7          |
      | qualification_round_batch       | 2 |
      | qualification_round_track_place | 5 |
      | final_round_batch       | 1  |
      | final_round_track_place | 3 |
    And I am on the race page
    Then I should not see "Lähtölista"
    And I should see "Alkukilpailun eräluettelot (PDF)"
    But I should not see "Kaikkien sarjojen lähtöajat (PDF)"
    When I follow "Alkukilpailun eräluettelot" within "#batch-links"
    Then I should be on the race qualification round batches page
    And the "Kilpailut" main menu item should be selected
    And the "Alkukilpailun eräluettelot" sub menu item should be selected
    And I should see batch 1 on track 1 with time "10:00"
    And I should see batch 2 on track 2 with time "10:30"
    And the batch 1 should contain a competitor "10. Testaaja Teppo (5), Testiseura (M)" in row 1
    And the batch 1 should contain a competitor "11. Testaaja Timo (6), Testiseura (M)" in row 2
    And the batch 2 should contain a competitor "5. Testinen Tyyne (7), Testiseura (N)" in row 1
    When I choose "Loppukilpailun eräluettelot" from sub menu
    Then I should be on the race final round batches page
    And the "Kilpailut" main menu item should be selected
    And the "Loppukilpailun eräluettelot" sub menu item should be selected
    And I should see batch 1 on track 1 with time "11:00"
    And the batch 1 should contain a competitor "3. Testinen Tyyne (7), Testiseura (N)" in row 1
    And the batch 1 should contain a competitor "4. Testaaja Timo (6), Testiseura (M)" in row 2
    And the batch 1 should contain a competitor "5. Testaaja Teppo (5), Testiseura (M)" in row 3
