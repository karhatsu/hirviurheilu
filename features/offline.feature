Feature: Offline usage
  In order to use the system as smoothly as possible
  As a customer without internet connection
  I want to exclude from offline usage such irrelevant features that are relevant in online usage

  Scenario: Simplified main page
    Given I use the software offline
    When I go to the home page
    Then I should not see "Hirviurheilu on hirvenhiihdon ja hirvenjuoksun internet-pohjainen"
    And I should not see "Kuinka Hirviurheilu-palvelua käytetään"
    And I should not see "Harjoittele palvelun käyttöä"
    And I should not see "Tämä on testiympäristö"

  Scenario: No pricing information
    Given I use the software offline
    When I am on the home page
    Then I should not see "Hinnat"
    When I follow "Info"
    Then I should not see "Hinnoittelu"

  Scenario: No registration, automatic official login
    Given I use the software offline
    When I am on the home page
    Then I should not see "Kirjaudu sisään"
    And I should not see "Kirjaudu ulos"
    And I should not see "Unohtunut salasana"
    And I should not see "Aloita"
    And I should not see "Omat tiedot"
    When I follow "Toimitsijan sivut"
    Then I should be on the official index page
    When I go to the account page
    Then I should be on the official index page

  Scenario: No official invitation
    Given I use the software offline
    And I have a race "Offline race"
    When I go to the official race page of "Offline race"
    Then I should not see "Toimitsijat"

  Scenario: No feedback form
    Given I use the software offline
    And I am on the home page
    When I follow "Lähetä palautetta"
    Then I should see "Lähetä palautetta" within "div.main_title"
    And I should see "Offline-versiossa et voi lähettää palautetta suoraan ohjelman kautta." within "div.info"
    But I should not see "Palaute"
    But I should not see "Nimi"
    But I should not see "Sähköposti"
    But I should not see "Puhelin"

  Scenario: Limited amount of companies until license is acquired
    Given there is an official with email "offline@hirviurheilu.com" and password "offline"
    Given there is an official with email "online@hirviurheilu.com" and password "online"
    Given I use the software offline
    And I am on the home page
    Then I should see "Voit lisätä vielä 20 kilpailijaa. Hanki lisenssi." within "div.offline_limit"
    Given I have a race "Offline race"
    And the race has series "Offline series"
    And the series has a competitor
    When I go to the home page
    Then I should see "Voit lisätä vielä 19 kilpailijaa. Hanki lisenssi." within "div.offline_limit"
    Given the series has 19 competitors
    When I go to the new competitor page of the series
    Then I should see "Voit lisätä vielä 0 kilpailijaa. Hanki lisenssi." within "div.offline_limit"
    And I should see "Olet tallentanut järjestelmään 20 kilpailijaa. Ennen kuin voit lisätä uusia kilpailijoita, sinun täytyy hankkia tuotteeseen lisenssi." within "div.error"
    But I should not see "Etunimi"
    When I follow "Hanki lisenssi"
    Then I should see "Hanki lisenssi" within "div.main_title"
    And I should see "Kirjaudu osoitteseen http://www.hirviurheilu.com/license omilla tunnuksillasi. Saat käyttöösi aktivointitunnuksen. Sen jälkeen syötä alla olevaan lomakkeseen saamasi aktivointitunnus sekä omat tunnuksesi." within "div.info"
    When I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I fill in "testkey123" for "Aktivointitunnus"
    And I press "Tallenna"
    Then I should see "Virheellinen aktivointitunnus" within "div.error"
    When I fill in "online@hirviurheilu.com" for "Sähköposti"
    And I fill in "online" for "Salasana"
    And I fill in "5bd11fe7d2" for "Aktivointitunnus"
    And I press "Tallenna"
    Then I should see "Hirviurheilun offline-versiosi on aktivoitu. Voit käyttää nyt tuotetta ilman rajoituksia." within "div.success"
    But I should not see "Voit lisätä vielä 0 kilpailijaa."
    When I go to the new competitor page of the series
    Then I should not see "Olet tallentanut järjestelmään 20 kilpailijaa."
    But I should see "Etunimi"
