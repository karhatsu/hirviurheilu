Feature: Manage race
  In order to be able to add competitors to a race
  As an official
  I need to create a race and edit race information

  Scenario: Create new race without default series
    Given I am an official "Teppo Testaaja"
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    Then I should be on the new race page
    And the official main menu item should be selected
    And I should see "Aloita valitsemalla laji" in an info message
    When I select "Hirvenhiihto" from "sport_key"
    And I press "Jatka"
    Then I should be on the new race page
    And I should not see "Aloita valitsemalla laji"
    And the "race_start_interval_seconds" field should contain "60"
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli | 30 |
    And I select "Test district" from "race_district_id"
    And I choose "Pääsääntöisesti sarjoittain"
    And I select "13" from "race_start_date_3i"
    And I select "heinäkuu" from "race_start_date_2i"
    And I select "2019" from "race_start_date_1i"
    And I press "Lisää kilpailu"
    Then I should be on the race edit page of "Test race"
    And the page title should contain "Test race"
    And I should see "Kilpailu lisätty."
    And I should see "Voit nyt lisätä sarjoja kilpailulle sivun alalaidasta."

  Scenario: Create new race with default series
    Given I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    And I select "Hirvenhiihto" from "sport_key"
    And I press "Jatka"
    Then I should be on the new race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli | 30 |
    And I select "Test district" from "race_district_id"
    And I choose "Pääsääntöisesti sarjoittain"
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    And the official main menu item should be selected
    And the "Yhteenveto" sub menu item should be selected
    And the page title should contain "Test race"
    And I should see "Kilpailu lisätty." in a success message
    And I should see "Aloita klikkaamalla sarjan nimen alla olevaa nappia." in an info message
    And I should see "M60"
    And I should see "N50"
    But I should not see "Sinulla ei ole vielä yhtään kilpailua."
    But I should not see "Et ole vielä lisännyt kilpailuun yhtään sarjaa."
    When I follow "Muokkaa kilpailun ja sarjojen asetuksia, lisää sarjoja"
    Then I should be on the race edit page of "Test race"
    But I should not see "Et ole vielä lisännyt kilpailuun yhtään sarjaa."

  @javascript
  Scenario: Create new race without default series and add series afterwards
    Given I am an official
    And I have logged in
    And I am on the new race page
    When I select "Hirvenjuoksu" from "sport_key"
    And I press "Jatka"
    And I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli | 30 |
    And I select "Test district" from "race_district_id"
    And I choose "Pääsääntöisesti sarjoittain"
    And I uncheck "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the race edit page of "Test race"
    And I should see "Et ole vielä lisännyt kilpailuun yhtään sarjaa. Lisää sarjoja yllä olevasta napista." in an info message
    When I press "Lisää uusi sarja tähän kilpailuun"
    And I fill in "Test series" for "Sarjan nimi"
    And I press "Lisää ikäryhmä"
    And I fill in "Test age group" for "Nimi"
    And I press the first "Tallenna kilpailun ja sarjojen tiedot" button
    Then I should be on the official race page of "Test race"
    And I should see "Test series"

  Scenario: Race has no series
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    When I go to the official index page
    And I follow "Test race"
    Then I should be on the official race page of "Test race"
    And I should see "Et ole vielä lisännyt kilpailuun yhtään sarjaa. Lisää sarjoja yllä olevasta napista." in an info message
    When I follow "Muokkaa kilpailun ja sarjojen asetuksia, lisää sarjoja"
    Then I should be on the race edit page of "Test race"
    And I should see "Et ole vielä lisännyt kilpailuun yhtään sarjaa. Lisää sarjoja yllä olevasta napista." in an info message

  Scenario: Create shooting race
    Given I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    And I select "Ilmahirvi" from "sport_key"
    And I press "Jatka"
    Then I should be on the new race page
    And I should not see "Lähtöajat"
    And I should not see "Lähtöerien koko"
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
    And I select "Test district" from "race_district_id"
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    And I should not see "Oikeat etäisyydet"
    When I follow "Muokkaa kilpailun ja sarjojen asetuksia, lisää sarjoja"
    Then I should see "Ilmahirvi"
    But I should not see "Lyhennetty matka"
    And I should not see "Pistelaskenta"
    And I should not see "Ikäryhmät, joille lasketaan omat aikapisteet"
    But I should see "Ikäryhmät joukkuekilpailua varten"

  Scenario: Edit race and series
    Given I am an official
    And I have a race "Test race"
    And the race has series "Test series"
    And I have logged in
    When I go to the official race page of "Test race"
    And I follow "Kilpailu & sarjat"
    And I fill in "New name for race" for "Kilpailun nimi"
    And I fill in "New race location" for "Paikkakunta"
    And I fill in "New name for series" for "Sarjan nimi"
    And I press the first "Tallenna kilpailun ja sarjojen tiedot" button
    Then I should be on the official race page of "New name for race"
    And the page title should contain "New name for race New race location"
    And I should see "New name for series"
    But I should not see "Test race"
    And I should not see "Test series"
