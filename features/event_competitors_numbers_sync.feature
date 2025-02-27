Feature: Synchronize numbers of the competitors within an event
  In order to simplify the processes around the competitors' numbers
  As an official
  I want to synchronize the numbers within an event

  @javascript
  Scenario: Synchronize competitor numbers
    Given I am an official
    And I have an event "Ilma-aseiden SM"
    And I have a "ILMALUODIKKO" race "SM ilmaluodikko" tomorrow
    And the race belongs to the event
    And the race has series "M"
    And the series has a competitor 5 "Timo" "Testinen" from "Testiseura"
    And the series has a competitor 10 "Teppo" "Testaaja" from "Testi AS"
    And the race has series "N"
    And the series has a competitor 1 "Tiina" "Testinen" from "Testiseura"
    And the series has a competitor 2 "Taina" "Testaaja" from "Testi AS"
    And the series has a competitor 3 "Tarja" "Testi" from "Testiseura"
    And I have a "ILMAHIRVI" race "SM ilmahirvi" tomorrow
    And the race belongs to the event
    And the race has series "M"
    And the series has a competitor 2 "Timo" "Testinen" from "Testiseura"
    And the series has a competitor 44 "Teppo" "Testaaja" from "Testi AS"
    And the series has a competitor 11 "Tuomo" "Testi" from "Testiseura"
    And the race has series "N"
    And the series has a competitor 9 "Tiina" "Testinen" from "Testiseura"
    And the series has a competitor 8 "Taina" "Testaaja" from "Testi AS"
    And I have logged in
    And I am on the official event page of "Ilma-aseiden SM"
    When I follow "Kilpailijat"
    Then I should see a card 1 with number 1, title "Testinen Tiina" and text "Testiseura"
    And I should see a card 2 with number 2, title "Testaaja Taina" and text "Testi AS"
    And I should see a card 3 with number 2, title "Testinen Timo" and text "Testiseura"
    And I should see a card 4 with number 3, title "Testi Tarja" and text "Testiseura"
    And I should see a card 5 with number 5, title "Testinen Timo" and text "Testiseura"
    When I follow "Synkronoi numerot"
    And I fill in "10" for "Ensimmäinen numero"
    And I check "Ymmärrän, että toiminto muuttaa kilpailijoiden numeroita alla olevissa kilpailuissa eikä vanhaa tilaa voi palauttaa"
    And I press "Synkronoi kilpailijanumerot"
    Then I should see "Kilpailijanumerot synkronoitu" in a success message
    When I follow "Kilpailijat"
    Then I should see a card 1 with number 10, title "Testinen Tiina" and text "Testiseura"
    And I should see a card 2 with number 11, title "Testaaja Taina" and text "Testi AS"
    And I should see a card 3 with number 12, title "Testi Tarja" and text "Testiseura"
    And I should see a card 4 with number 13, title "Testinen Timo" and text "Testiseura"
    And I should see a card 5 with number 14, title "Testaaja Teppo" and text "Testi AS"
    And I should see a card 6 with number 15, title "Testi Tuomo" and text "Testiseura"
