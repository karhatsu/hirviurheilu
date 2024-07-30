Feature: Heat list
  In order to know when I am about to shoot
  As a competitor
  I want to see the heat list

  @javascript
  Scenario: No heats defined
    Given there is a "ILMAHIRVI" race "No heats race"
    And the race has series "M"
    And the series has a competitor "Teppo" "Testinen"
    And I am on the race page
    Then I should not see "Lähtölista"
    And I should not see "Alkukilpailun eräluettelo" within ".menu--sub"
    And I should not see "Loppukilpailun eräluettelo" within ".menu--sub"
    Then I go to the race qualification round heats page
    And I should see "Alkukilpailun eräluettelo" within "h2"
    And I should see "Kilpailun eräluetteloa ei ole tehty" in an info message
    Then I go to the race final round heats page
    And I should see "Loppukilpailun eräluettelo" within "h2"
    And I should see "Kilpailun eräluetteloa ei ole tehty" in an info message

  @javascript
  Scenario: Race with heats
    Given there is a "ILMALUODIKKO" race "Heats race"
    And the race has a club "Testiseura"
    And the race has a qualification round heat 1 with track 1 and time "10:00"
    And the race has a qualification round heat 2 with track 2 and time "10:30"
    And the race has a final round heat 1 with track 1 and time "11:00"
    And the race has series "M"
    And the series has a competitor with attributes:
      | first_name  | Teppo      |
      | last_name   | Testaaja   |
      | club        | Testiseura |
      | number      | 5          |
      | qualification_round_heat       | 1  |
      | qualification_round_track_place | 10 |
      | final_round_heat       | 1  |
      | final_round_track_place | 5 |
    And the series has a competitor with attributes:
      | first_name  | Timo       |
      | last_name   | Testaaja   |
      | club        | Testiseura |
      | number      | 6          |
      | qualification_round_heat       | 1  |
      | qualification_round_track_place | 11 |
      | final_round_heat       | 1  |
      | final_round_track_place | 4 |
    And the race has series "N"
    And the series has a competitor with attributes:
      | first_name  | Tyyne      |
      | last_name   | Testinen   |
      | club        | Testiseura |
      | number      | 7          |
      | qualification_round_heat       | 2 |
      | qualification_round_track_place | 5 |
      | final_round_heat       | 1  |
      | final_round_track_place | 3 |
    And I am on the race page
    Then I should not see "Lähtölista"
    And I should see "Alkukilpailun eräluettelo (PDF)"
    But I should not see "Kaikkien sarjojen lähtöajat (PDF)"
    When I follow "Alkukilpailun eräluettelo" within "#heat-links"
    Then I should be on the race qualification round heats page
    And the "Alkukilpailun eräluettelo" sub menu item should be selected
    And I should see heat 1 on track 1 with time "10:00"
    And I should see heat 2 on track 2 with time "10:30"
    And the heat 1 should contain a competitor "10. Testaaja Teppo (5), Testiseura (M)" in row 1
    And the heat 1 should contain a competitor "11. Testaaja Timo (6), Testiseura (M)" in row 2
    And the heat 2 should contain a competitor "5. Testinen Tyyne (7), Testiseura (N)" in row 1
    When I choose "Loppukilpailun eräluettelo" from sub menu
    Then I should be on the race final round heats page
    And the "Loppukilpailun eräluettelo" sub menu item should be selected
    And I should see heat 1 on track 1 with time "11:00"
    And the heat 1 should contain a competitor "3. Testinen Tyyne (7), Testiseura (N)" in row 1
    And the heat 1 should contain a competitor "4. Testaaja Timo (6), Testiseura (M)" in row 2
    And the heat 1 should contain a competitor "5. Testaaja Teppo (5), Testiseura (M)" in row 3
