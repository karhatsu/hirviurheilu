Feature: Official only adding competitors
  In order to protect my race data but still save my effort by allowing others to add competitors
  As a race main official
  I want to allow certain officials only adding new competitors but doing nothing else
  
  Scenario: Race official with limited rights sees only limited competitors page
    Given I am a limited official for the race "Limited race"
    And the race has series "Limited series"
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
    
  Scenario: Race official with limited rights can add a competitor
    Given I am a limited official for the race "Limited race"
    And the race has series "Limited series"
    And I have logged in
    When I go to the the limited official competitors page for "Limited race"
    Then I should not see "Lisätyt kilpailijat"
    When I press "Tallenna"
    Then I should see "Etunimi on pakollinen" in an error message
    When I fill in "Keijo" for "Etunimi"
    And I fill in "Kisaaja" for "Sukunimi"
    And I press "Tallenna"
    Then I should be on the the limited official competitors page for "Limited race"
    And I should see "Kilpailija lisätty" in a success message
    And I should see "Lisätyt kilpailijat"
    And I should see "Kisaaja Keijo" within "#all_competitors"
    When I fill in "Heikki" for "Etunimi"
    And I fill in "Hiihtäjä" for "Sukunimi"
    And I press "Tallenna"
    Then I should see "Kisaaja Keijo, Hiihtäjä Heikki" within "#all_competitors"
    
  Scenario: No series added for the race
    Given I am a limited official for the race "Limited race"
    And I have logged in
    And I am on the the limited official competitors page for "Limited race"
    Then I should see "Tähän kilpailuun ei ole vielä lisätty yhtään sarjaa. Voit lisätä kilpailijoita vasta sen jälkeen, kun päätoimitsija on lisännyt kilpailuun sarjat." in a warning message
    But I should not see "Etunimi"
    And I should not see "Lisätyt kilpailijat"
    