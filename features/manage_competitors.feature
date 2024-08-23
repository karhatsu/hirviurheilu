Feature: Manage competitors
  In order to be able to create start lists for my race
  As an official
  I want to add and edit competitors

  Scenario: When race has series but no competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    When I go to the official index page
    And I follow "Test race"
    Then I should see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa. Aloita klikkaamalla sarjan nimen alla olevaa nappia." in an info message
    When I go to the official competitors page of the series
    Then I should see "Et ole syöttänyt tähän sarjaan vielä yhtään kilpailijaa." in an info message
    When I follow "Lisää kilpailija"
    Then I should be on the new competitor page of the series

  Scenario: Edit competitor before and after start list is created
    Given I am an official
    And I have a race "Test race"
    And the race has a series "Series A" with first number 10 and start time "00:00:00"
    And the series has a competitor "Mary" "Smith"
    And the start list has been generated for the series
    And the race has series "Series B"
    And the race has series "Series C"
    And the race has series "Series D"
    And the series has a competitor "James" "Johnson"
    And I have logged in
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    Then I should not see "Saapumisaika"
    And I should not see "Ammunta yhteensä"
    And I should not see "Arvio 1"
    And the series menu should contain options "Series B,Series C,Series D"
    And "Series D" should be selected in the series menu
    When I fill in "" for "Etunimi"
    And I press "Tallenna"
    Then I should see "Etunimi on pakollinen" in an error message
    When I fill in "Peter" for "Etunimi"
    And I fill in "Ford" for "Sukunimi"
    And I select "Series B" from "Sarja"
    And I fill in "New club" for "club_name"
    And I press "Tallenna"
    Then I should be on the official competitors page of series "Series B"
    And I should see "Ford Peter"
    And I should see "New club"
    When I press "Luo lähtölista sarjalle"
    And I follow "Ford Peter"
    Then I should see "Saapumisaika"
    And I should see "Ammunta yhteensä"
    And I should see "Arvio 1"
    And the "competitor_start_time" text field value should be "00:01:00"
    When I fill in "95" for "Ammunta yhteensä"
    And I fill in "00:23:45" for "competitor_arrival_time"
    And I fill in "120" for "Arvio 1"
    And I fill in "100" for "Arvio 2"
    And I press "Tallenna"
    Then I should be on the official competitors page of series "Series B"
    And the card 1 main value should be "done"
    When I follow "Ford Peter"
    Then the "competitor_arrival_time" text field value should be "00:23:45"

  @javascript
  Scenario: Updating competitor without shots, adding shots, updating shots
    Given I am an official
    And I have a race "Test race"
    And the race has a club "Testiseura"
    And the race has series with attributes:
      | first_number | 10 |
      | start_time | 01:00 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Testiseura |
    And the start list has been generated for the series
    And I have logged in
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I wait for the results
    Then I should not see "0, 0, 0, 0, 0, 0, 0, 0, 0, 0"
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I fill shots "10,10,10,10,10,9,9,9,8,0"
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I wait for the results
    Then I should see "85 / 10, 10, 10, 10, 10, 9, 9, 9, 8, 0)"
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I fill shots "10,10,10,5,10,9,9,9,8,7"
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I wait for the results
    Then I should see "87 / 10, 10, 10, 5, 10, 9, 9, 9, 8, 7)"

  @javascript
  Scenario: Update competitor in start list page
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_order | 2 |
    And the race has series "M60"
    And the series has an age group "M65"
    And the series has an age group "M70"
    And the race has series "M"
    And the series has a competitor with attributes:
      | first_name | Tom      |
      | last_name  | Johnson  |
      | number     | 12       |
      | start_time | 00:00:30 |
    And I have logged in
    And I am on the official race page of "Test race"
    When I choose "Lähtöajat" from sub menu
    And I update the first competitor values to "M60"/"M70", "Tim", "Smith", "New club", "00:10:30", 567 in start list page
    And I press "Tallenna"
    Then I should see "Tallennettu"
    When I go to the official competitors page of series "M60"
    Then I should see "Smith Tim"
    And I should see "M60"
    And I should see "(M70)"
    And I should see "00:10:30"
    And I should see "567"
    And I should see "New club"

  Scenario: Update shooting race competitor
    Given I am an official
    And I have a "METSASTYSHIRVI" race "Hirvi test race"
    And the race has series "N60"
    And the series has a competitor "Heidi" "Hirvi"
    And I have logged in
    And I am on the official race page of "Hirvi test race"
    And I choose "Kilpailijat" from sub menu
    And I follow "Hirvi Heidi"
    When I fill in "Hirvelä" for "Sukunimi"
    And I fill in "97" for "Alkukilpailun yhteistulos"
    And I fill in "99" for "Loppukilpailun yhteistulos"
    And I press "Tallenna"
    Then I should be on the official competitors page of series "N60"
    And I should see "Hirvelä Heidi"
    When I choose "Ammunta sarjoittain" from sub menu
    Then the card 1 main value should be "97 + 99 = 196"

  @javascript
  Scenario: Update shotgun race competitor
    Given I am an official
    And I have a "METSASTYSTRAP" race "Trap test race"
    And the race has series "M"
    And the series has a competitor "Timo" "Trap"
    And I have logged in
    And I am on the official race page of "Trap test race"
    And I choose "Kilpailijat" from sub menu
    And I follow "Trap Timo"
    When I fill in "Teppo" for "Etunimi"
    And I select qualification round shotgun shots from 2 to 23
    And I select final round shotgun shots from 1 to 21
    When I press "Tallenna"
    Then I should be on the official competitors page of series "M"
    And I should see "Trap Teppo"
    When I choose "Ammunta sarjoittain" from sub menu
    Then the card 1 main value should be "22 + 21 = 43"

  Scenario: Update european race competitor
    Given I am an official
    And I have a "EUROPEAN" race "European test race"
    And the race has series "M60"
    And the series has a competitor "Eetu" "Eurooppalainen"
    And I have logged in
    And I am on the official race page of "European test race"
    And I choose "Kilpailijat" from sub menu
    And I follow "Eurooppalainen Eetu"
    When I fill in "Erkki" for "Etunimi"
    And I fill in "24" for "Trapin tulos"
    And I fill in "25" for "Compakin tulos"
    And I fill in "51" for "Metsäkauriin tulos"
    And I fill in "48" for "Ketun tulos"
    And I fill in "40" for "Gemssin tulos"
    And I fill in "50" for "Villisian tulos"
    And I press "Tallenna"
    Then I should see "Metsäkauriin tulos täytyy olla pienempi tai yhtä suuri kuin 50" in a error message
    And I fill in "50" for "Metsäkauriin tulos"
    And I press "Tallenna"
    Then I should be on the official competitors page of series "M60"
    And I should see "Eurooppalainen Erkki"
    When I choose "Luodikko" from sub menu
    Then the card 1 main value should be "188"

  Scenario: Update nordic race competitor
    Given I am an official
    And I have a "NORDIC" race "Nordic test race"
    And the race has series "S20"
    And the series has a competitor "Nipa" "Nordic"
    And I have logged in
    And I am on the official race page of "Nordic test race"
    And I choose "Kilpailijat" from sub menu
    And I follow "Nordic Nipa"
    When I fill in "Niemelä" for "Sukunimi"
    And I fill in "26" for "Trapin tulos"
    And I fill in "25" for "Compakin tulos"
    And I fill in "99" for "Liikkuvan hirven tulos"
    And I fill in "90" for "Seisovan kauriin tulos"
    And I press "Tallenna"
    Then I should see "Trapin tulos täytyy olla pienempi tai yhtä suuri kuin 25" in a error message
    And I fill in "25" for "Trapin tulos"
    And I press "Tallenna"
    Then I should be on the official competitors page of series "S20"
    And I should see "Niemelä Nipa"
    When I choose "Trap" from sub menu
    Then the card 1 main value should be "25"
