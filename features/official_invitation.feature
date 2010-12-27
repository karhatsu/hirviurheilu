Feature: Official invitation
  In order to share my official responsibility
  As an official
  I want to invite other officials to work with my race

  Scenario: Invite official that exists in the database
    Given there exists an official "Another Official" with email "another@official.com"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race with attributes:
      | sport | SKI |
      | name | Test race |
      | location | Test town |
      | start_date | 2010-12-12 |
      | end_date | 2010-12-13 |
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    Then I should be on the invite officials page for "Test race"
    And I should see "Toimitsijat" within "h2"
    And I should see "Tim Thomas" within "#current_officials"
    When I fill in "another@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi" within "div.notice"
    And I should see "Tim Thomas, Another Official" within "#current_officials"
    And "another@official.com" should receive an email with subject "Kutsu kilpailun Test race toimitsijaksi"
    When "another@official.com" opens the email
    Then they should see "Hei Another Official" in the email body
    And they should see "Tim Thomas on kutsunut sinut toimitsijaksi Hirviurheilu-palvelussa olevaan Hirvenhiihtokilpailuun: Test race (12.12.2010 - 13.12.2010, Test town)" in the email body
    And they should see "Hirviurheilu-palvelun osoite:" in the email body
    And they should see "http://www.example.com" in the email body

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
