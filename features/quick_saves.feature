Feature: Quick result save
  In order to save time and bandwidth
  As an official
  I want to save individual results quickly with Quick save

  Scenario: Go to quick save page
    Given I am an official
    And I have a race "Relay race"
    And the race has series "M"
    And the series has a competitor
    And I have logged in
    And I am on the official race page of "Relay race"
    When I follow "Pikasyöttö"
    Then the official main menu item should be selected
    And the "Pikasyöttö" sub menu item should be selected
    And I should see "Tulosten pikasyöttö"

  @javascript
  Scenario: Save arrival time
    Given I am an official
    And I have a race "Quick race"
    And the race has a series "Miehet" with first number 1 and start time "10:00"
    And the series has a competitor "Tomi" "Testinen"
    And the start list has been generated for the series
    And I have logged in
    And I am on the official quick save page of "Quick race"
    And I fill in "1,103045" for "time_string"
    And I press "submit_time"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (saapumisaika: 10:30:45)."

  @javascript
  Scenario: Save estimates
    Given I am an official
    And I have a race "Quick race"
    And the race has a series "Miehet" with first number 1 and start time "10:00"
    And the series has a competitor "Tomi" "Testinen"
    And the start list has been generated for the series
    And I have logged in
    And I am on the official quick save page of "Quick race"
    And I fill in "1,89,145" for "estimates_string"
    And I press "submit_estimates"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (arviot: 89 ja 145)."

  @javascript
  Scenario: Save shots
    Given I am an official
    And I have a race "Quick race"
    And the race has a series "Miehet" with first number 1 and start time "10:00"
    And the series has a competitor "Tomi" "Testinen"
    And the start list has been generated for the series
    And I have logged in
    And I am on the official quick save page of "Quick race"
    And I fill in "1,93" for "shots_string"
    And I press "submit_shots"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (ammunta: 93)."
    Given I fill in "++1,+987654321" for "shots_string"
    And I press "submit_shots"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (ammunta: 55)."
    