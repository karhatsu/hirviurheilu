Feature: Official invitation
  In order to share my official responsibility
  As an official
  I want to invite other officials to work with my race

  Scenario: Invite official that exists in the database
    Given there exists an official "Another Official" with email "another@official.com"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    Then I should be on the officials page for "Test race"
    And I should see "Toimitsijat" within "h2"
    And I should see "Tim Thomas" within "#current_officials"
    When I fill in "another@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi" within "div.notice"
    And I should see "Tim Thomas, Another Official" within "#current_officials"

  Scenario: Try to invite official that does not exist in the database
    Given I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    When I fill in "another@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Tietokannasta ei löytynyt syöttämääsi sähköpostiosoitetta" within "div.error"
    And I should see "Tim Thomas" within "#current_officials"

  Scenario: Try to invite an official that already is an official for this race
    Given I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    When I fill in "tim@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Henkilö on jo tämän kilpailun toimitsija" within "div.error"
    And I should see "Tim Thomas" within "#current_officials"
