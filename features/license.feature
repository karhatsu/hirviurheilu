Feature: License
  In order to be able to use my offline product with full power
  As an offline product user
  I want to see my license key in the online service

  Scenario: Show license key
    Given I am an official with email "license@hirviurheilu.com" and password "license"
    And I have logged in
    And I am on the account page
    When I follow "Hanki lisenssi offline-tuotetta varten"
    Then I should see "Hanki lisenssi offline-tuotetta varten" within "div.main_title"
    And I should see "Tältä sivulta voit hankkia offline-tuotteeseen lisenssin, joka poistaa tuotteesta käyttörajoitukset. Jos käytät Hirviurheilu-palvelua pelkästään internetin välityksellä, sinun ei tarvitse hankkia lisenssiä." within "div.info"
    And I should see "TÄRKEÄÄ! Jos hankit lisenssin, se tarkoittaa sitä, että Hirviurheilu-palvelulla on oikeus laskuttaa sinua Offline-tuotteesta riippumatta siitä, käytätkö sitä vai et." within "div.warning"
    When I press "Näytä aktivointitunnus"
    Then I should see "Sinun täytyy hyväksyä käyttöehdot" within "div.error"
    When I check "Hyväksyn käyttöehdot ja ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä."
    And I press "Näytä aktivointitunnus"
    Then I should see "Aktivointitunnus:"
    And I should see "CC81E12F02"
    And I should see "Siirry seuraavaksi offline-tuotteen puolelle ja syötä sinne tämän palvelun käyttäjätunnukset sekä yllä oleva aktivointitunnus." within "div.info"
    Given I follow "Kirjaudu ulos"
    And I am an admin
    And I have logged in
    When I follow "Admin"
    And I follow "Käyttäjät"
    # TODO...
    Then I should "License acquired"
