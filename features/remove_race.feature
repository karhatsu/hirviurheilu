Feature: Remove race
  As an official/admin
  I want to remove races
  So that I can get rid of useless test data

  Scenario: Remove race when it has no competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Poista kilpailu"
    Then I should be on the official index page
    And I should see "Kilpailu poistettu" in a success message

  Scenario: Cannot remove race when it has competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series "Test series"
    And the series has a competitor
    And I have logged in
    And I am on the official race page of "Test race"
    Then the page should not contain the remove race button

  Scenario: Cannot remove race when it has relays
    Given I am an official
    And I have a race "Test race"
    And the race has a relay "Test relay"
    And I have logged in
    And I am on the official race page of "Test race"
    Then the page should not contain the remove race button

  Scenario: Remove race as an admin
    Given there is a race "Test race 1" with series, competitors, team competitions, and relays
    And there is a race "Test race 2"
    And I am an admin
    And I have logged in
    And I am on the admin index page
    When I follow "Kilpailut" within ".menu--sub"
    Then I should be on the admin races page
    And the "Admin" main menu item should be selected
    And the "Kilpailut" sub menu item should be selected
    And I should see "Test race 1"
    And I should see "Test race 2"
    When I choose to delete the race "Test race 1"
    And I fill in "Wrong name" for "Vahvista poisto syöttämällä kilpailun nimi"
    And I press "Poista kilpailu"
    Then I should see "Kilpailun nimi on väärä" in an error message
    When I fill in "Test race 1" for "Vahvista poisto syöttämällä kilpailun nimi"
    And I press "Poista kilpailu"
    Then I should be on the admin races page
    And I should see "Kilpailu poistettu" in a success message
    And I should see "Test race 2"
    But I should not see "Test race 1"
    And the race should be completely removed from the database
