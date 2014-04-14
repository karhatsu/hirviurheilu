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
    And I should see "Hanki aktivointitunnus Offline-tuotetta varten" within "div.main_title"
    And I should see "Tältä sivulta voit hankkia Offline-tuotteeseen aktivointitunnuksen, joka poistaa tuotteesta käyttörajoitukset. Jos käytät Hirviurheilu-palvelua pelkästään internetin välityksellä, sinun ei tarvitse hankkia aktivointitunnusta."
    And I should see "TÄRKEÄÄ! Jos avaat aktivointitunnuksen, se tarkoittaa sitä, että Hirviurheilu-palvelulla on oikeus laskuttaa sinua Offline-tuotteesta riippumatta siitä, käytätkö sitä vai et." in an warning message
    When I fill in "license" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Sinun täytyy hyväksyä laskutusehto" in an error message
    When I check "Ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä"
    And I fill in "wrong password" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Väärä salasana" in an error message
    When I check "Ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä"
    And I fill in "license" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Syötä laskutustiedot" in an error message
    When I check "Ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä"
    And I fill in "license" for "Salasana"
    And I fill in "Testiseura" for "Laskutustiedot (esim. seuran nimi)"
    And I press "Näytä aktivointitunnus"
    Then I should see "Aktivointitunnus: CC81E12F02" in a success message
    And I should see "Siirry seuraavaksi offline-tuotteen puolelle ja syötä sinne tämän palvelun käyttäjätunnukset sekä yllä oleva aktivointitunnus." in an info message
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - aktivointitunnus katsottu" in the email subject
    And I should see "Käyttäjä: Mathew Stevensson (license@hirviurheilu.com)" in the email body
    And I should see "Laskutustiedot: Testiseura" in the email body
    And I should see "Aktivointitunnus: CC81E12F02" in the email body
    Given I follow "Kirjaudu ulos"
    And I am an admin
    And I have logged in
    When I follow "Admin"
    And I choose "Käyttäjät" from sub menu
    Then I should see "CC81E12F02"
    
  Scenario: When user has already checked the activation key, just ask password
    Given I am an official "Mathew Stevensson" with email "license@hirviurheilu.com" and password "license"
    And I have already opened the activation key with invoicing info "Laskutusseura"
    And I have logged in
    And I change my password to "new-password"
    When I go to the offline price page
    And I follow "Hanki aktivointitunnus"
    Then I should not see "Laskutustiedot"
    And I should not see "Hirviurheilu Offline -tuotteen hinta"
    And I should not see "Ymmärrän, että minua laskutetaan Hirviurheilu offline-tuotteen käytöstä"
    When I fill in "new-password" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Aktivointitunnus: 3DD4C0AA32" in a success message
    And the admin should receive no emails

  Scenario: Unauthenticated user wants to see activation key
    Given I go to the activation key page
    Then I should be on the login page

  Scenario: Staging environment user tries to see activation key
    Given I use the service in the staging environment
    And I am an official
    And I have logged in
    And I go to the activation key page
    Then I should see "Voit hankkia aktivointitunnuksen vain varsinaisesta Hirviurheilu Online -palvelusta." in an error message
    But I should not see "Salasana"
    And I should not see "Hyväksyn käyttöehdot"

  Scenario: User tries to access license page in online mode
    Given I go to the new license page
    Then I should be on the home page
