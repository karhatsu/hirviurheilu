Feature: Official invitation
  In order to share my official responsibility
  As an official
  I want to invite other officials to work with my race

  Scenario: Invite official that exists in the database
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword"
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
    And the official main menu item should be selected
    And the "Toimitsijat" sub menu item should be selected
    And I should see "Toimitsijat" within "h2"
    And I should see "Tim Thomas" within "#current_officials"
    When I fill in "another@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi" in a success message
    And I should see "Tim Thomas, Another Official" within "#current_officials"
    And "another@official.com" should receive an email with subject "Kutsu kilpailun Test race toimitsijaksi"
    When I logout
    And "another@official.com" opens the email
    Then I should see "Hei Another Official" in the email body
    And I should see "Tim Thomas on kutsunut sinut toimitsijaksi Hirviurheilu-palvelussa olevaan Hirvenhiihtokilpailuun: Test race (12.12.2010 - 13.12.2010, Test town)" in the email body
    And I should see "Linkki kilpailuun:" in the email body
    When I click the first link in the email
    Then I should be on the login page
    When I fill in "another@official.com" for "Sähköposti"
    And I fill in "pword" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the official race page of "Test race"

  Scenario: Try to invite official that does not exist in the database
    Given I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    When I fill in "another@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Tietokannasta ei löytynyt syöttämääsi sähköpostiosoitetta" in an error message
    And I should see "Tim Thomas" within "#current_officials"

  Scenario: Try to invite an official that already is an official for this race
    Given I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    When I fill in "tim@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Henkilö on jo tämän kilpailun toimitsija" in an error message
    And I should see "Tim Thomas" within "#current_officials"

  Scenario: Invite official with only rights to add competitors
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword"
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
    When I fill in "another@official.com" for "Sähköposti"
    And I check "Anna käyttäjälle ainoastaan oikeudet lisätä kilpailijoita"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi rajoitetuin oikeuksin" in a success message
    And I should see "Tim Thomas, Another Official (vain kilpailijoiden lisäys)" within "#current_officials"
    And "another@official.com" should receive an email with subject "Kilpailun Test race kilpailijoiden lisäyspyyntö"
    When I logout
    And "another@official.com" opens the email
    Then I should see "Hei Another Official" in the email body
    And I should see "Tim Thomas on pyytänyt sinua lisäämään kilpailijoita Hirviurheilu-palvelussa olevaan Hirvenhiihtokilpailuun: Test race (12.12.2010 - 13.12.2010, Test town)" in the email body
    And I should see "Siirry syöttämään kilpailijoita:" in the email body
    When I click the first link in the email
    Then I should be on the login page
    When I fill in "another@official.com" for "Sähköposti"
    And I fill in "pword" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the limited official competitors page for "Test race"
  