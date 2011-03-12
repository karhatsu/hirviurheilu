Feature: Manage race
  In order to be able to add competitors to a race
  As an official
  I need to create a race and edit race information

  Scenario: Create new race without default series
    Given I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    Then I should be on the new race page
    And the "race_start_interval_seconds" field should contain "60"
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli (sekuntia) | 30 |
    And I press "Lisää kilpailu"
    Then I should be on the race edit page of "Test race"
    And I should see "Test race" within ".main_title"
    And I should see "Kilpailu lisätty."
    And I should see "Voit nyt lisätä sarjoja kilpailulle alla olevasta napista."

  Scenario: Create new race with default series
    Given there is a default series "Default series 1"
    And there is a default series "Default series 2"
    And I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi kilpailu"
    Then I should be on the new race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
      | Lähtöaikojen väli (sekuntia) | 30 |
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    And I should see "Test race" within ".main_title"
    And I should see "Kilpailu lisätty."
    And I should see "Pääset lisäämään kilpailijoita klikkaamalla sarjan nimen vieressä olevaa linkkiä."
    And I should see "Default series 1"
    And I should see "Default series 2"
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
    And I should see "Et ole vielä lisännyt kilpailuun yhtään sarjaa. Lisää sarjoja alla olevasta linkistä." within "div.info"
