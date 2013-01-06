Feature: Official only adding competitors
  In order to protect my race data but still save my effort by allowing others to add competitors
  As a race main official
  I want to allow certain officials only adding new competitors but doing nothing else
  
  Scenario: Race official with limited rights sees only limited competitors page
    Given I am a limited official for the race "Limited race"
    And the race has series "Limited series"
    And the race has a club "Limited club"
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
    And the race has series "M"
    And the race has series "N"
    And the race has a club "Limited club"
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
    And I should see "Lisätyt kilpailijat (1)"
    And I should see "Kisaaja Keijo (M)" within "#all_competitors"
    When I fill in "Helena" for "Etunimi"
    And I fill in "Hiihtäjä" for "Sukunimi"
    And I select "N" from "Sarja"
    And I press "Tallenna"
    Then I should see "Hiihtäjä Helena (N), Kisaaja Keijo (M)" within "#all_competitors"
    And I should see "Lisätyt kilpailijat (2)"
    
  Scenario: When limitation is on club level, club is defined automatically
    Given there is a race "Limited race"
    And the race has series "M"
    And the race has a club "Some other club"
    And the race has a club "My club"
    And the series "M" contains a competitor with attributes:
      | first_name | Teppo |
      | club | Some other club |
    And I have limited rights to add competitors to the club "My club" in the race
    And I have logged in
    When I go to the limited official competitors page for "Limited race"
    Then I should see "My club"
    But I should not see "Some other club"
    But I should not see "Teppo"
    When I fill in "Keijo" for "Etunimi"
    And I fill in "Kisaaja" for "Sukunimi"
    And I press "Tallenna"
    Then I should be on the the limited official competitors page for "Limited race"
    And I should see "Kilpailija lisätty" in a success message
    And I should see "Lisätyt kilpailijat (1)"
    And I should see "Kisaaja Keijo (M)" within "#all_competitors"
    
  Scenario: No series added for the race
    Given I am a limited official for the race "Limited race"
    And the race has a club "Limited club"
    And I have logged in
    And I am on the the limited official competitors page for "Limited race"
    Then I should see "Tähän kilpailuun ei ole vielä lisätty yhtään sarjaa. Voit lisätä kilpailijoita vasta sen jälkeen, kun päätoimitsija on lisännyt kilpailuun sarjat." in a warning message
    But I should not see "Etunimi"
    
  Scenario: No clubs added for the race
    Given I am a limited official for the race "Limited race"
    And the race has series "Limited series"
    And I have logged in
    And I am on the the limited official competitors page for "Limited race"
    Then I should see "Tähän kilpailuun ei ole vielä lisätty yhtään piiriä tai seuraa. Voit lisätä kilpailijoita vasta sen jälkeen, kun päätoimitsija on lisännyt kilpailuun piirit/seurat." in a warning message
    But I should not see "Etunimi"
    