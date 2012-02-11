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
    And the "race_start_interval_seconds" field should contain "60"
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli (sekuntia) | 30 |
    And I select "13" from "race_start_date_3i"
    And I select "heinäkuu" from "race_start_date_2i"
    And I select "2011" from "race_start_date_1i"
    And I uncheck "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the race edit page of "Test race"
    And I should see "Test race" within ".main_title"
    And I should see "Kilpailu lisätty."
    And I should see "Voit nyt lisätä sarjoja kilpailulle alla olevasta linkistä."
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - uusi kilpailu (test)" in the email subject
    And I should see "Kilpailun nimi: Test race" in the email body
    And I should see "Aika: 13.07.2011" in the email body
    And I should see "Paikkakunta: Test town" in the email body
    And I should see "Toimitsija: Teppo Testaaja" in the email body

  Scenario: Create new race with default series
    Given I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    Then I should be on the new race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli (sekuntia) | 30 |
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    And the official main menu item should be selected
    And the "Yhteenveto" sub menu item should be selected
    And I should see "Test race" within ".main_title"
    And I should see "Kilpailu lisätty."
    And I should see "Pääset lisäämään kilpailijoita klikkaamalla sarjan nimen vieressä olevaa linkkiä."
    And I should see "M60"
    And I should see "N50"
    But I should not see "Sinulla ei ole vielä yhtään kilpailua."
    But I should not see "Et ole vielä lisännyt kilpailuun yhtään sarjaa."
    When I follow "Muokkaa kilpailun ja sarjojen asetuksia, lisää sarjoja"
    Then I should be on the race edit page of "Test race"
    But I should not see "Et ole vielä lisännyt kilpailuun yhtään sarjaa."

  Scenario: Race has no series
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    When I go to the official index page
    And I follow "Test race"
    Then I should be on the official race page of "Test race"
    And I should see "Et ole vielä lisännyt kilpailuun yhtään sarjaa. Lisää sarjoja alla olevasta linkistä." within "div.info"
    When I follow "Muokkaa kilpailun ja sarjojen asetuksia, lisää sarjoja"
    Then I should be on the race edit page of "Test race"
    And I should see "Et ole vielä lisännyt kilpailuun yhtään sarjaa. Lisää sarjoja alla olevasta napista." within "div.info"

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
    And I press "Tallenna kilpailun ja sarjojen tiedot"
    Then I should be on the official race page of "New name for race"
    And I should see "New name for race (New race location" within ".main_title"
    And I should see "New name for series"
    But I should not see "Test race"
    And I should not see "Test series"
