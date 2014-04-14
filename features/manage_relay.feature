Feature: Manage relays
  In order to show relay results
  As an official
  I want to add and edit relays and fill results for them

  Scenario: Create relay
    Given I am an official
    And I have a race "Relay race"
    And I have logged in
    And I am on the official race page of "Relay race"
    When I choose "Viestit" from sub menu
    Then the official main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should be on the official relays page of "Relay race"
    And I should see "Viestit" within "h2"
    When I follow "Lisää viesti"
    Then the official main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should see "Uusi viesti" within "h2"
    And I should see "Huom! Osuuksien määrää ei voi muuttaa sen jälkeen, kun viesti on luotu." in an warning message
    And the "Osuuksien määrä" field should contain "4"
    When I press "Tallenna"
    Then I should see "Viestin nimi on pakollinen" in an error message
    When I fill in "Test relay" for "Viestin nimi"
    And I fill in "3" for "Osuuksien määrä"
    And I select "11" from "relay_start_time_4i"
    And I select "45" from "relay_start_time_5i"
    And I press "Tallenna"
    Then I should be on the edit relay page of "Test relay"
    And I should see "Viesti luotu. Voit nyt lisätä viestiin joukkueita." in a success message
    And I should see "Et ole vielä lisännyt viestiin yhtään joukkuetta. Lisää joukkueita alla olevasta napista." in an info message
    And the "Viestin nimi" field should contain "Test relay"
    And I should see "3"
    And the "relay_start_time_4i" field should contain "11"
    And the "relay_start_time_5i" field should contain "45"
    When I follow "Takaisin viestien etusivulle"
    Then I should be on the official relays page of "Relay race"
    And I should see "Test relay"
    And I should see "3"
    And I should see "11:45"

  Scenario: Edit relay
    Given I am an official
    And I have a race "Relay race"
    And the race has a relay "Test relay"
    And I have logged in
    And I am on the official relays page of "Relay race"
    When I follow "Test relay"
    Then I should see "Muokkaa viestin tietoja"
    But I should not see "Huom! Osuuksien määrää"
    When I fill in "" for "Viestin nimi"
    And I press "Tallenna"
    Then I should see "Viestin nimi on pakollinen" in an error message
    When I fill in "New name" for "Viestin nimi"
    And I select "08" from "relay_start_time_4i"
    And I select "12" from "relay_start_time_5i"
    And I press "Tallenna"
    Then I should be on the official relays page of "Relay race"
    And I should see "Viestin tiedot päivitetty" in a success message
    And I should see "New name"
    And I should see "08:12"

  Scenario: Relay results quick save
    Given I am an official
    And I have a race "Relay race"
    And the race has a relay with attributes:
      | name | Test relay |
      | legs_count | 2 |
    And the relay has a team "Test team"
    And the relay team has a competitor with attributes:
      | first_name | Tim |
      | last_name | Smith |
      | leg | 1 |
    And the relay team has a competitor with attributes:
      | first_name | John |
      | last_name | Stevenson |
      | leg | 2 |
    And I have logged in
    And I am on the official relays page of "Relay race"
    When I follow "Tulosten pikasyöttö"
    Then the official main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should see "Viesti - Test relay - Tulosten pikasyöttö" within "h2"

  Scenario: Finish relay
    Given I am an official
    And I have a race "Relay race"
    And the race has a relay with attributes:
      | name | Test relay |
      | legs_count | 2 |
      | start_time | 12:00 |
    And the relay has a team "Test team"
    And I have logged in
    And I am on the official relays page of "Relay race"
    When I follow "Viestin päättäminen"
    Then I should be on the finish relay page of "Test relay"
    And the official main menu item should be selected
    And the "Viestit" sub menu item should be selected
    And I should see "Viestin päättäminen" within "h2"
    And I should see "Kun kaikki viestin tiedot on syötetty, voit alla olevan napin avulla merkitä viestin päättyneeksi. Ohjelma tarkastaa automaattisesti, ettei mitään tietoja puutu." in an info message
    Given the relay team is deleted
    When I press "Merkitse viesti päättyneeksi"
    Then I should see "Viestissä ei ole yhtään joukkuetta" in an error message
    Given the relay has a team "Test team"
    And the relay team has a competitor with attributes:
      | first_name | Tim |
      | last_name | Smith |
      | leg | 1 |
      | arrival_time | 00:15:10 |
      | misses | 0 |
      | estimate | 91 |
    And the relay team has a competitor with attributes:
      | first_name | John |
      | last_name | Stevenson |
      | leg | 2 |
      | arrival_time | 00:31:12 |
      | misses | 1 |
    And the relay has the correct estimates:
      | leg | distance |
      | 1 | 105 |
      | 2 | 88 |
    When I press "Merkitse viesti päättyneeksi"
    Then I should see "Osalta kilpailijoista puuttuu arvio" in an error message
    Given the estimate for the relay competitor "John" "Stevenson" is 75
    When I press "Merkitse viesti päättyneeksi"
    Then I should be on the official relays page of "Relay race"
    And I should see "Viesti 'Test relay' merkitty päättyneeksi" in a success message
    And I should see "Viesti päättynyt" within "table"
    But I should not see "Viestin päättäminen"
    When I go to the finish relay page of "Test relay"
    Then I should see "Tämä viesti on jo merkitty päättyneeksi" in an info message
    But I should not see "Kun kaikki viestin tiedot on syötetty"
    When I follow "Takaisin viestien etusivulle"
    Then I should be on the official relays page of "Relay race"
