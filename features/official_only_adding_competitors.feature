Feature: Official only adding competitors
  In order to protect my race data but still save my effort by allowing others to add competitors
  As a race main official
  I want to allow certain officials only adding new competitors but doing nothing else
  
  Scenario: Race official with limited rights sees only limited competitors page
    Given I am an official
    And there is a race "Limited race"
    And the race has series "Limited series"
    And I have only add competitors rights for the race
    And I have logged in
    And I am on the official index page
    When I follow "Limited race"
    Then I should be on the limited official competitors page for "Limited race"
    And I should see "Limited race" within ".main_title"
    And the "Toimitsijan sivut" main menu item should be selected
    And the "Kilpailijat" sub menu item should be selected
    And I should not see "Yhteenveto"
    And I should not see "Kilpailu & sarjat"
    And I should not see "Lähtöajat"
    And I should not see "Pikasyöttö"
    And I should not see "Ajat"
    And I should not see "Arviot"
    And I should not see "Ammunta"
    And I should not see "Oikeat arviot"
    And I should not see "Joukkuek"
    And I should not see "Viestit"
    And I should not see "Seurat"
    And I should not see "Toimitsijat"
    And I should not see "Lataa"
    When I go to the race edit page of "Limited race"
    Then I should be on the limited official competitors page for "Limited race"
    When I go to the official relays page of "Limited race"
    Then I should be on the limited official competitors page for "Limited race"
    