Feature: Manager relays
  In order to show relay results
  As an official
  I want to add and edit relays and fill results for them

  Scenario: Create relay
    Given I am an official
    And I have a race "Relay race"
    And I have logged in
    And I am on the official race page of "Relay race"
    When I follow "Viestit"
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should be on the official relays page of "Relay race"
    And I should see "Viestit" within "h2"
    When I follow "Lisää viesti"
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should see "Uusi viesti" within "h2"
    And the "Osuuksien määrä" field should contain "4"
    When I press "Tallenna"
    Then I should see "Viestin nimi on pakollinen" within "div.error"
    When I fill in "Test relay" for "Viestin nimi"
    And I fill in "3" for "Osuuksien määrä"
    And I select "11" from "relay_start_time_4i"
    And I select "45" from "relay_start_time_5i"
    And I press "Tallenna"
    Then I should be on the official relays page of "Relay race"
    And I should see "Viesti luotu. Klikkaa Joukkueet-linkkiä, niin pääset lisäämään viestiin osallistuvat joukkueet." within "div.success"
    And I should see "Test relay"
    And I should see "3"
    And I should see "11:45"

  Scenario: Edit relay
    Given I am an official
    And I have a race "Relay race"
    And the race has a relay "Test relay"
    And I have logged in
    And I am on the official relays page of "Relay race"
    When I follow "Muokkaa"
    And I fill in "" for "Viestin nimi"
    And I press "Tallenna"
    Then I should see "Viestin nimi on pakollinen" within "div.error"
    When I fill in "New name" for "Viestin nimi"
    And I select "08" from "relay_start_time_4i"
    And I select "12" from "relay_start_time_5i"
    And I press "Tallenna"
    Then I should be on the official relays page of "Relay race"
    And I should see "Viestin tiedot päivitetty" within "div.success"
    And I should see "New name"
    And I should see "08:12"
