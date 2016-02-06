Feature: Mobile usage
  As a mobile phone user
  I want that the page UI fits nicely to my mobile devise screen
  So that it is easy to use the pages

  Scenario: Force mobile option
    Given I am on the home page
    And I follow "Mobiilinäkymä"
    Then I should be on the home page
    And I should see "Tulevat kilpailut"
    But I should not see "Kilpailun järjestäjille"
    When I follow "Normaalinäkymä"
    Then I should be on the home page
    And I should see "Tulevat kilpailut"
    And I should see "Kilpailun järjestäjille"

  Scenario: Show mobile home page
    Given there is a race "Finished race" in the past
    And there is a race "Today's race" today
    And there is a race "Upcoming race" in the future
    And there is an active front page announcement with title "Active announcement" and content "Mobile UI released"
    And I use the mobile UI
    Then I should see "Finished race" within "div.old_races"
    And I should see "Today's race" within "div.races_today"
    And I should see "Upcoming race" within "div.future_races"
    And I should see "Active announcement" within "div.announcements"
    When I follow "Active announcement"
    Then I should see "Active announcement"
    And I should see "Mobile UI released"
    When I follow "Takaisin etusivulle"
    Then I should be on the home page

  Scenario: See results in mobile view
    Given there is a race "Mobile race"
    And the race has series with attributes:
      | name | Men 50 years |
      | start_time | 00:00 |
      | first_number | 1 |
    And the race has correct estimates with attributes:
      | min_number | 1 |
      | max_number | 100 |
      | distance1 | 110 |
      | distance2 | 130 |
    And the race has a club "Mobile club"
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Mobile club |
    And the start list has been generated for the series
    And the competitor "James" "Johnson" has the following results:
      | shots_total_input | 85 |
      | estimate1 | 111 |
      | estimate2 | 129 |
      | arrival_time | 00:15:10 |
    And the race is finished
    And I am on the home page
    When I follow "Mobiilinäkymä"
    And I follow "Mobile race"
    Then I should be on the race page of "Mobile race"
    When I follow "00:00"
    Then I should be on the start list page of the series
    And I should see "Mobile race - Men 50 years - Lähtölista" within "h2"
    And I should see "Johnson James"
    And I should see "00:00"
    When I follow "Takaisin sivulle Mobile race"
    When I follow "Men 50 years"
    Then I should be on the results page of the series
    And I should see "Mobile race - Men 50 years - Tulokset" within "h2"
    And I should see a result row 1 with values:
      | name | Johnson James |
      | number | 1. |
      | club | Mobile club |
      | points | 1106 |

  Scenario: Send feedback in mobile view
    Given I am on the home page
    And I follow "Mobiilinäkymä"
    When I follow "Palaute"
    Then I should be on the send feedback page
    When I fill in the following:
      | Palaute    | Hyvä järjestelmä! |
      | Nimi       | Pekka Miettinen   |
      | Sähköposti | pekka@palaute.com |
      | Puhelin    | 123 456           |
      | captcha    | 4                 |
    When I press "Lähetä"
    Then I should see "Kiitos palautteesta"
    And the admin should receive an email
    When I open the email
    Then I should see the email delivered from "pekka@palaute.com"
    And I should see "Hirviurheilu - palaute" in the email subject
    And I should see "Hyvä järjestelmä!" in the email body
    And I should see "Nimi: Pekka Miettinen" in the email body
    And I should see "Sähköposti: pekka@palaute.com" in the email body
    And I should see "Puhelin: 123 456" in the email body
    And I should see "Ympäristö: test" in the email body
