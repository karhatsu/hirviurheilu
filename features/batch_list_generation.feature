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
    And the batch 1 should contain competitor "Anttila Antti" in the track place 1
    And the batch 1 should contain competitor "Heikkilä Heikki" in the track place 2
    And the batch 1 should contain competitor "Iivonen Iivo" in the track place 3
    And I should see "Erä: 2, 10:30 (Rata 2)"
    And the batch 2 should contain competitor "Jannela Janne" in the track place 1
    And the batch 2 should contain competitor "Mattila Matti" in the track place 2
    And the batch 2 should contain competitor "Pekkanen Pekka" in the track place 3
    And I should see "Erä: 3, 10:50 (Rata 1)"
    And the batch 3 should contain competitor "Testinen Timo" in the track place 1
