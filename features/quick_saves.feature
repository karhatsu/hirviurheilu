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
  Scenario: Save arrival time, estimates, and shots
    Given I am an official
    And I have a race "Quick race" with competitor "Tomi" "Testinen" in series "Miehet", with number 1 and start time "00:00"
    And I have logged in
    And I am on the official quick save page of "Quick race"
    When I fill in "1,003045" for "time_string"
      And I press "submit_time"
      Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Saapumisaika: 00:30:45, Aika: 30:45)."
    When I fill in "1,89,145" for "estimates_string"
      And I press "submit_estimates"
      Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Arviot: 89 ja 145)."
    When I fill in "1,93" for "shots_string"
      And I press "submit_shots"
      Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Ammunta: 93)."
    When I fill in "++1,+987654321" for "shots_string"
      And I press "submit_shots"
      Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Ammunta: 55)."

  @javascript
  Scenario: Save arrival time, estimates, and shots in alternative format
    Given I am an official
    And I have a race "Quick race" with competitor "Tomi" "Testinen" in series "Miehet", with number 1 and start time "00:00"
    And I have logged in
    And I am on the official quick save page of "Quick race"
    When I fill in "1#003045" for "time_string"
    And I press "submit_time"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Saapumisaika: 00:30:45, Aika: 30:45)."
    When I fill in "1#89#145" for "estimates_string"
    And I press "submit_estimates"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Arviot: 89 ja 145)."
    When I fill in "1#93" for "shots_string"
    And I press "submit_shots"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Ammunta: 93)."
    When I fill in "++1#*987654321" for "shots_string"
    And I press "submit_shots"
    Then I should see "Kilpailijan 1. Testinen Tomi (Miehet) tulos tallennettu onnistuneesti (Ammunta: 55)."
