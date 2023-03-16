Feature: Megalink import

  @javascript
  Scenario: Import qualification round shots
    Given I am an official
    And I have a "ILMALUODIKKO" race "Test race"
    And the race has a qualification round batch 1 with competitors assigned to track places 11-40
    And I have logged in
    And I am on the official race page of "Test race"
    And I follow "Megalink-tulokset"
    And I choose "Alkukilpailu"
    And I paste the file "megalink_qr1.json" contents to the Megalink data field
    And I press "Tallenna"
    Then I should see "Tulokset tallennettu" in a success message
    And the competitor in qualification round batch 1 on place 11 should have shots "9, 11, 8, 11, 11, 9, 11, 5, 11, 11, 11, 11, 9, 5, 9, 11, 11, 3, 6, 6"
    And the competitor in qualification round batch 1 on place 40 should have shots "8, 9, 11, 11, 11, 9, 0, 6, 11, 11, 6, 9, 6, 11, 11, 3, 11, 0, 11, 3"
