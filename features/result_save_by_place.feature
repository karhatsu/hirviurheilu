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
    And I should see "296 (+1m / -1m)"
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

  @javascript
  Scenario: Save shotgun race shots
    Given I am an official
    And I have a "METSASTYSHAULIKKO" race "Shotgun test race"
    And the race has series "M70"
    And the series has a competitor
    And I have logged in
    And I am on the official race page of "Shotgun test race"
    When I choose "Ammunta sarjoittain" from sub menu
    And I select qualification round shotgun shots from 1 to 23
    Then the card 1 main value should be "23 + 0 = 23"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    And I select final round shotgun shots from 3 to 24
    Then the card 1 main value should be "23 + 22 = 45"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Ammunta sarjoittain" from sub menu
    Then the card 1 main value should be "23 + 22 = 45"

  @javascript
  Scenario: Save nordic race shots
    Given I am an official
    And I have a "NORDIC" race "Nordic test race"
    And the race has series "N"
    And the series has a competitor "Nanna" "Nordic"
    And I have logged in
    And I am on the official race page of "Nordic test race"
    When I choose "Trap" from sub menu
    And I select qualification round shotgun shots from 2 to 23
    Then the card 1 main value should be "22"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Compak" from sub menu
    And I select qualification round shotgun shots from 3 to 25
    Then the card 1 main value should be "23"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Hirvi" from sub menu
    And I fill nordic rifle moving shots "9,10,10,10,7,9,9,9,8,0"
    Then the card 1 main value should be "81"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Kauris" from sub menu
    And I fill nordic rifle standing shots "10,10,9,9,7,9,9,9,8,0"
    Then the card 1 main value should be "80"
    When I press "Tallenna"
    And I go to the results page of the series
    And I wait for the results
    Then I should see 261 as total score in the results table for row 1

  @javascript
  Scenario: Save european race shots
    Given I am an official
    And I have a "EUROPEAN" race "European test race"
    And the race has series "M"
    And the series has a competitor
    And I have logged in
    And I am on the official race page of "European test race"
    When I choose "Trap" from sub menu
    And I select qualification round shotgun shots from 1 to 25
    Then the card 1 main value should be "25"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Compak" from sub menu
    And I select qualification round shotgun shots from 2 to 24
    Then the card 1 main value should be "23"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I choose "Luodikko" from sub menu
    And I fill european rifle shots "9,9,8,8,9", "10,10,10,10,10", "9,10,9,9,10" and "10,9,8,8,0"
    Then the card 1 main value should be "175"
    When I press "Tallenna"
    Then I should see "Tallennettu" in a success message
    When I go to the results page of the series
    And I wait for the results
    Then I should see 367 as total score in the results table for row 1
    When I choose "Luodikko" from sub menu
    And I wait for the results
    Then I should see 175 as total score in the results table for row 1
