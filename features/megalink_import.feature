Feature: Megalink import

  @javascript
  Scenario: Import qualification and final round shots
    Given I am an official
    And I have a race with attributes:
      | sport_key  | ILMALUODIKKO |
      | start_date | 2023-03-01   |
      | name       | Test race    |
    And the race has a qualification and final round batch 1 with competitors assigned to track places 11-40
    And I have logged in
    And I am on the official race page of "Test race"
    And I follow "Megalink-tulokset"
    And I choose "Alkukilpailu"
    And I paste the file "megalink_qr1.json" contents to the Megalink data field
    And I press "Tallenna"
    Then I should see "Tulokset tallennettu" in a success message
    And the competitor in qualification round batch 1 on place 11 should have shots "9, 11, 8, 11, 11, 9, 11, 5, 11, 11, 11, 11, 9, 5, 9, 11, 11, 3, 6, 6"
    And the competitor in qualification round batch 1 on place 40 should have shots "8, 9, 11, 11, 11, 9, 0, 6, 11, 11, 6, 9, 6, 11, 11, 3, 11, 0, 11, 3"
    When I choose "Loppukilpailu"
    And I paste the file "megalink_final1.json" contents to the Megalink data field
    And I press "Tallenna"
    Then I should see "Tulokset tallennettu" in a success message
    And the competitor in final round batch 1 on place 11 should have shots "9, 11, 8, 11, 11, 9, 11, 5, 11, 11, 11, 11, 9, 5, 9, 11, 11, 3, 6, 6, 9, 11, 11, 0, 11, 11, 4, 11, 9, 5"
    And the competitor in final round batch 1 on place 40 should have shots "8, 9, 11, 11, 11, 9, 0, 6, 11, 11, 6, 9, 6, 11, 11, 3, 11, 0, 11, 3, 11, 7, 11, 11, 7, 7, 0, 0, 6, 3"
