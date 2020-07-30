Feature: Save results by result place
  So that results can be calculated
  As an official
  I want to save results for different result places

  @javascript
  Scenario: Save estimates, shots, and arrival time
    Given I am an official
    And I have a race "Result race"
    And the race has a series "M" with first number 10 and start time "01:00"
    And the series has a competitor "Mikko" "Mallikas"
    And the race has correct estimates with attributes:
      | min_number | 10  |
      | max_number | 10  |
      | distance1  | 99  |
      | distance2  | 150 |
    And the start list has been generated for the series
    And I have logged in
    And I am on the official race page of "Result race"
    When I follow "Arviot"
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Arviot" sub menu item should be selected
    And I should see "Result race" within ".body__on-top-title"
    When I fill in "100" for "competitor[estimate1]"
    And I fill in "149" for "competitor[estimate2]"
    And I press "Tallenna"
    Then I should see "Tallennettu"
    When I choose "Ajat" from sub menu
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Ajat" sub menu item should be selected
    And I should see "Result race" within ".body__on-top-title"
    And the "competitor[start_time]" text field value should be "01:00:00"
    And the "competitor[arrival_time]" text field value should be ""
    When I fill in "01:25:41" for "competitor[arrival_time]"
    And I press "Tallenna"
    Then I should see "Tallennettu"
    When I choose "Ammunta" from sub menu
    Then the "Toimitsijan sivut" main menu item should be selected
    And the "Ammunta" sub menu item should be selected
    And I should see "Result race" within ".body__on-top-title"
    When I fill in "99" for "competitor[shooting_score_input]"
    And I press "Tallenna"
    Then I should see "Tallennettu"
    When I choose "Ajat" from sub menu
    Then the "competitor[start_time]" text field value should be "01:00:00"
    And the "competitor[arrival_time]" text field value should be "01:25:41"
    When the race is finished
    And I go to the results page of the series
    Then I should see "300 (25:41)"
    And I should see "296 (+1m/-1m)"
    And I should see "594 (99)"

  @javascript
  Scenario: Prevent concurrent changes for same competitor's same estimate results
    Given I am an official
    And I have a race "Result race"
    And the race has a series "M" with first number 10 and start time "01:00"
    And the series has a competitor "Mikko" "Mallikas"
    And the start list has been generated for the series
    And I have logged in
    And I am on the official race page of "Result race"
    And I follow "Arviot"
    Then I should see "M - Arviot"
    Given someone else saves estimates 100 and 150 for the competitor
    When I fill in "101" for "competitor[estimate1]"
    And I fill in "151" for "competitor[estimate2]"
    And I press "Tallenna"
    Then I should not see "Tallennettu"
    But I should see "Virhe"
    And I should see "Tälle kilpailijalle on syötetty samanaikaisesti toinen tulos. Lataa sivu uudestaan ja yritä tallentamista sen jälkeen."

  @javascript
  Scenario: Save shooting race shots
    Given I am an official
    And I have a "ILMALUODIKKO" race "Air test race"
    And the race has series "M70"
    And the series has a competitor "Iivari" "Ilma"
    And I have logged in
    And I am on the official race page of "Air test race"
    When I choose "Ammunta sarjoittain" from sub menu
    And I fill qualification round shots "9,10,10,10,,9,9,9,8,0"
    And I press "Tallenna"
    Then I should see "Virhe: Osa laukauksista on jätetty tyhjiksi, käytä nollaa ohilaukauksille." in an error message
    When I fill qualification round shots "9,10,10,10,7,9,9,9,8,0"
    Then the card 1 main value should be "81 + 0 = 81"
    And I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I fill final round shots "9,9,10,10,10,8,8,8,10,10"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Ammunta sarjoittain" from sub menu
    Then the card 1 main value should be "81 + 92 = 173"
