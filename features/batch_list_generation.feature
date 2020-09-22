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
