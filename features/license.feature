Feature: License
  In order to be able to use my offline product with full power
  As an offline product user
  I want to see my activation key in the online service

  Scenario: Show activation key
    Given I am an official "Mathew Stevensson" with email "license@hirviurheilu.com" and password "license"
    And I have logged in
    And I am on the offline price page
    When I follow "Hanki aktivointitunnus"
    Then the "Offline" main menu item should be selected
    And the "Hanki aktivointitunnus" sub menu item should be selected
    And I should see "Hanki aktivointitunnus offline-tuotetta varten" within "div.main_title"
    And I should see "Tältä sivulta voit hankkia offline-tuotteeseen aktivointitunnuksen, joka poistaa tuotteesta käyttörajoitukset. Jos käytät Hirviurheilu-palvelua pelkästään internetin välityksellä, sinun ei tarvitse hankkia aktivointitunnusta." within "div.info"
    And I should see "TÄRKEÄÄ! Jos avaat aktivointitunnuksen, se tarkoittaa sitä, että Hirviurheilu-palvelulla on oikeus laskuttaa sinua Offline-tuotteesta riippumatta siitä, käytätkö sitä vai et." within "div.warning"
    When I fill in "license" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Sinun täytyy hyväksyä käyttöehdot" within "div.error"
    When I check "Hyväksyn käyttöehdot ja ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä"
    And I fill in "wrong password" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Väärä salasana" within "div.error"
    When I check "Hyväksyn käyttöehdot ja ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä"
    And I fill in "license" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Aktivointitunnus: CC81E12F02" within "div.success"
    And I should see "Siirry seuraavaksi offline-tuotteen puolelle ja syötä sinne tämän palvelun käyttäjätunnukset sekä yllä oleva aktivointitunnus." within "div.info"
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - aktivointitunnus katsottu" in the email subject
    And I should see "Käyttäjä: Mathew Stevensson" in the email body
    And I should see "Aktivointitunnus: CC81E12F02" in the email body
    Given I follow "Kirjaudu ulos"
    And I am an admin
    And I have logged in
    When I follow "Admin"
    And I follow "Käyttäjät"
    Then I should see "CC81E12F02"

  Scenario: Unauthenticated user wants to see activation key
    Given I go to the activation key page
    Then I should be on the login page

  Scenario: Staging environment user tries to see activation key
    Given I use the service in the staging environment
    And I am an official
    And I have logged in
    And I go to the activation key page
    Then I should see "Voit hankkia aktivointitunnuksen vain varsinaisesta Hirviurheilu Online -palvelusta." within "div.error"
    But I should not see "Salasana"
    And I should not see "Hyväksyn käyttöehdot"

  Scenario: User tries to access license page in online mode
    Given I go to the new license page
    Then I should be on the home page
