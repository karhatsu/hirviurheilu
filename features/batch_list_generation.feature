Feature: Batch list generation
  In order to save time
  As an official
  I want to generate batch lists automatically with certain rules

  Scenario: No necessary race attributes set
    Given I am an official
    And I have logged in
    And I have a "ILMALUODIKKO" race "Air race"
    And the race has series "M"
    And the series has a competitor
    And I am on the official race page of "Air race"
    When I follow "Alkukilpailun erien asettelu arpomalla"
    And the official main menu item should be selected
    And the "Alkukilpailu" sub menu item should be selected
    Then I should see "Kilpailulle pitää määrittää ratojen lukumäärä ja ammuntapaikkojen lukumäärä ennen kuin voi arpoa eräluettelon" in an error message
    When I follow "Perustiedot"
    And I fill in "2" for "Ratojen määrä"
    And I fill in "3" for "Ammuntapaikkoja / rata"
    And I press the first "Tallenna kilpailun ja sarjojen tiedot" button
    And I follow "Alkukilpailu"
    Then I should see "Ensimmäinen kilpailija arvotaan erään numero"
    But I should not see "Tällä työkalulla voit arpoa trapin suoritusajat"

  Scenario: Generate qualification round batch lists
    Given I am an official
    And I have logged in
    And I have a race with attributes:
      | name | Test race |
      | sport_key | METSASTYSHIRVI |
      | track_count | 2        |
      | shooting_place_count | 3 |
    And the race has series "M"
    And the series has a competitor "Antti" "Anttila"
    And the series has a competitor "Heikki" "Heikkilä"
    And the series has a competitor "Iivo" "Iivonen"
    And the series has a competitor "Janne" "Jannela"
    And the series has a competitor "Matti" "Mattila"
    And the series has a competitor "Timo" "Testinen"
    And the series has a competitor "Pekka" "Pekkanen"
    And I am on the official race page of "Test race"
    And I follow "Alkukilpailu"
    And I press "Arvo eräluettelot"
    Then I should see "Ensimmäinen erän kellonaika on virheellinen. Erälle varattu aika on virheellinen" in an error message
    Given batch list generation sorts competitors by last name
    And I fill in "10:30" for "Ensimmäisen erän kellonaika"
    And I fill in "20" for "Erälle varattu aika (min)"
    And I press "Arvo eräluettelot"
    Then I should see "Alkukilpailun eräluettelot luotu sarjalle onnistuneesti" in a success message
    And I should see "Sarjassa ei ole yhtään kilpailijaa, jolta puuttuisi alkukilpailun ammuntapaikka" in an info message
    And I should see "Erä: 1, 10:30 (Rata 1)"
    And the batch 1 card 1 should contain competitor "Anttila Antti" in the track place 1
    And the batch 1 card 2 should contain competitor "Heikkilä Heikki" in the track place 2
    And the batch 1 card 3 should contain competitor "Iivonen Iivo" in the track place 3
    And I should see "Erä: 2, 10:30 (Rata 2)"
    And the batch 2 card 1 should contain competitor "Jannela Janne" in the track place 1
    And the batch 2 card 2 should contain competitor "Mattila Matti" in the track place 2
    And the batch 2 card 3 should contain competitor "Pekkanen Pekka" in the track place 3
    And I should see "Erä: 3, 10:50 (Rata 1)"
    And the batch 3 card 1 should contain competitor "Testinen Timo" in the track place 1

  Scenario: Generate final round batch lists
    Given I am an official
    And I have logged in
    And I have a race with attributes:
      | name | Test race |
      | sport_key | ILMALUODIKKO |
      | track_count | 2        |
      | shooting_place_count | 5 |
    And the race has series "M"
    And the series has a competitor "Antti" "Anttila" with qualification round result 98
    And the series has a competitor "Heikki" "Heikkilä" with qualification round result 100
    And the series has a competitor "Iivo" "Iivonen" with qualification round result 94
    And the series has a competitor "Janne" "Jannela" with qualification round result 99
    And the series has a competitor "Matti" "Mattila" with qualification round result 97
    And the series has a competitor "Timo" "Testinen" with qualification round result 96
    And the series has a competitor "Pekka" "Pekkanen" with qualification round result 95
    And I am on the official race page of "Test race"
    And I follow "Loppukilpailu"
    And I press "Tee eräluettelot"
    Then I should see "Ensimmäinen erän kellonaika on virheellinen. Erälle varattu aika on virheellinen" in an error message
    And I fill in "13:00" for "Ensimmäisen erän kellonaika"
    And I fill in "15" for "Erälle varattu aika (min)"
    And I check "Sijoita paras kilpailija erän viimeiseksi"
    And I check "Jätä erän ensimmäinen paikka tyhjäksi"
    And I check "Jätä erän viimeinen paikka tyhjäksi"
    And I press "Tee eräluettelot"
    Then I should see "Loppukilpailun eräluettelot luotu sarjalle onnistuneesti" in a success message
    And I should see "Erä: 1, 13:00 (Rata 1)"
    And the batch 1 card 1 should contain competitor "Iivonen Iivo" in the track place 2
    And the batch 1 card 2 should contain competitor "Pekkanen Pekka" in the track place 3
    And the batch 1 card 3 should contain competitor "Testinen Timo" in the track place 4
    And I should see "Erä: 2, 13:00 (Rata 2)"
    And the batch 2 card 1 should contain competitor "Mattila Matti" in the track place 2
    And the batch 2 card 2 should contain competitor "Anttila Antti" in the track place 3
    And the batch 2 card 3 should contain competitor "Jannela Janne" in the track place 4
    And I should see "Erä: 3, 13:15 (Rata 1)"
    And the batch 3 card 1 should contain competitor "Heikkilä Heikki" in the track place 2

  Scenario: Generate batch lists for nordic race
    Given I am an official
    And I have logged in
    And I have a race with attributes:
      | name | Test race |
      | sport_key | NORDIC |
      | track_count | 2        |
      | shooting_place_count | 10 |
    And the race has series "M"
    And the series has a competitor "Antti" "Anttila"
    And the series has a competitor "Heikki" "Heikkilä"
    And the series has a competitor "Iivo" "Iivonen"
    And the series has a competitor "Janne" "Jannela"
    And the series has a competitor "Matti" "Mattila"
    And the series has a competitor "Timo" "Testinen"
    And the series has a competitor "Pekka" "Pekkanen"
    And I am on the official race page of "Test race"
    When I choose "Erien arvonta" from sub menu
    Then the official main menu item should be selected
    And the "Erien arvonta" sub menu item should be selected
    And I should see "Tällä työkalulla voit arpoa trapin suoritusajat"
    Given batch list generation sorts competitors by last name
    When I fill in "12:50" for "Ensimmäisen erän kellonaika"
    And I fill in "15" for "Erälle varattu aika (min)"
    And I choose "only_track_places_odd"
    And I fill in "1,7" for "Vapaaksi jätettävät ammuntapaikat (pilkulla erotettuina, esim. 4,12,13)"
    And I press "Arvo eräluettelot"
    And I should see "Erä: 1, Trap: 12:50 (Rata 1)"
    And the batch 1 card 1 should contain competitor "Anttila Antti" in the track place 3
    And the batch 1 card 2 should contain competitor "Heikkilä Heikki" in the track place 5
    And the batch 1 card 3 should contain competitor "Iivonen Iivo" in the track place 9
    And I should see "Erä: 2, Trap: 12:50 (Rata 2)"
    And the batch 2 card 1 should contain competitor "Jannela Janne" in the track place 3
    And the batch 2 card 2 should contain competitor "Mattila Matti" in the track place 5
    And the batch 2 card 3 should contain competitor "Pekkanen Pekka" in the track place 9
    And I should see "Erä: 3, Trap: 13:05 (Rata 1)"
    And the batch 3 card 1 should contain competitor "Testinen Timo" in the track place 3
    When I choose "Erät" from sub menu
    And I click the card 1
    And I select "10" from "batch_time2_4i"
    And I select "20" from "batch_time2_5i"
    And I select "15" from "batch_time3_4i"
    And I select "00" from "batch_time3_5i"
    And I select "17" from "batch_time4_4i"
    And I select "45" from "batch_time4_5i"
    And I press "Tallenna"
    And I should see "Trap: 12:50 - Compak: 10:20 - Hirvi: 15:00 - Kauris: 17:45 (Rata 1)"
