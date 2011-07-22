Feature: Club level
  So that clubs for competitors would be correct
  As a newbie official
  I want to clearly know what to write for the club field

  Scenario: Show "Seura" as default club title
    Given I am an official
    And I have logged in
    And I am on the new official race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    And I should see "Seurat" within ".sub_menu"

  Scenario: Show "Piiri" as club title when that level is selected
    Given I am an official
    And I have logged in
    And I am on the new official race page
    Then I should see "Kilpailijan edustustaso tässä kilpailussa"
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
    And I check "Lisää oletussarjat automaattisesti"
    And I choose "Piiri"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    And I should see "Piirit" within ".sub_menu"
