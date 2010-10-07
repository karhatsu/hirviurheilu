Feature: Official
  In order to manage races
  As a race official
  I want to access the official pages and fill in race information

  Scenario: Unauthenticated user cannot get to the official pages
    Given I go to the official index page
    Then I should be on the login page

  Scenario: Official registration
    Given I go to the registration page
    When I fill in the following:
      | Etunimi | Tim |
      | Sukunimi | Tester |
      | Sähköposti | tim@tester.com |
      | Salasana | testpassword |
      | Salasana uudestaan | testpassword |
    And I press "Rekisteröidy"
    Then I should see "Käyttäjätili luotu."
    When I follow "Toimitsijan etusivu"
    Then I should be on the official index page

  Scenario: Official goes to the official index
    Given I am an official with email "test@test.com" and password "test"
    And I am on the home page
    When I follow "Toimitsijan etusivu"
    Then I should be on the login page
    When I fill in "test@test.com" for "Sähköposti"
    And I fill in "test" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the official index page

  Scenario: Create new race without default series
    Given I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    Then I should be on the new race page
    When I fill in the following:
      | Nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli (sekuntia) | 30 |
    And I press "Lisää kilpailu"
    Then I should be on the race edit page of "Test race"
    And I should see "Test race" within "h1"
    And I should see "Kilpailu lisätty."
    And I should see "Voit nyt lisätä sarjoja kilpailulle alla olevasta linkistä."

  Scenario: Create new race with default series
    Given there is a default series "Default series 1"
    And there is a default series "Default series 2"
    And I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    Then I should be on the new race page
    When I fill in the following:
      | Nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli (sekuntia) | 30 |
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official index page
    And I should see "Test race" within "h2"
    And I should see "Kilpailu lisätty."
    And I should see "Pääset lisäämään kilpailijoita klikkaamalla sarjan nimen vieressä olevaa linkkiä."
    And I should see "Default series 1"
    And I should see "Default series 2"

  Scenario: Add competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And there is a club "Test club"
    And I have logged in
    And I am on the official index page
    When I follow "Muokkaa asetuksia, lisää kilpailijoita, syötä tulostietoja"
    And I follow "Lisää uusi kilpailija"
    And I fill in the following:
      | Etunimi | Tom |
      | Sukunimi | Stevensson |
    And I press "Tallenna ja lisää toinen kilpailija"
    And I fill in the following:
      | Etunimi | Math |
      | Sukunimi | Heyton |
    And I press "Tallenna ja palaa sarjan tietoihin"
    Then I should be on the edit page of "Test series"
    And I should see "Stevensson Tom"
    And I should see "Heyton Math"
