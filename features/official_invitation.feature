Feature: Official invitation
  In order to share my official responsibility
  As an official
  I want to invite other officials to work with my race

  Scenario: Invite official that exists in the database
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword123"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race with attributes:
      | sport_key | SKI |
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
    And current officials card 1 should contain "Thomas Tim" with full rights
    When I fill in "Another@Official.COM" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi" in a success message
    And current officials card 1 should contain "Official Another" with full rights
    And current officials card 2 should contain "Thomas Tim" with full rights
    And "another@official.com" should receive an email with subject "Hirviurheilu - kutsu kilpailun Test race toimitsijaksi"
    When I logout
    And "another@official.com" opens the email
    Then I should see "Hei Another Official" in the email body
    And I should see "Tim Thomas on kutsunut sinut toimitsijaksi Hirviurheilu-palvelussa olevaan kilpailuun" in the email body
    And I should see "Test race (12.12.2010 - 13.12.2010, Test town)" in the email body
    And I should see "Linkki kilpailuun:" in the email body
    When I click the first link in the email
    Then I should be on the login page
    When I fill in "another@official.com" for "Sähköposti"
    And I fill in "pword123" for "Salasana"
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

  Scenario: Try to invite an official that already is an official for this race
    Given I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the race edit page of "Test race"
    When I follow "Toimitsijat"
    When I fill in "tim@official.com" for "Sähköposti"
    And I press "Lähetä kutsu"
    Then I should see "Henkilö on jo tämän kilpailun toimitsija" in an error message

  Scenario: Invite official with only rights to add competitors
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword123"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race with attributes:
      | sport_key | SKI |
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
    And current officials card 1 should contain "Official Another" with limited rights to all clubs
    And "another@official.com" should receive an email with subject "Hirviurheilu - kilpailun Test race kilpailijoiden lisäyspyyntö"
    When I logout
    And "another@official.com" opens the email
    Then I should see "Hei Another Official" in the email body
    And I should see "Tim Thomas on pyytänyt sinua lisäämään kilpailijoita Hirviurheilu-palvelussa olevaan kilpailuun:" in the email body
    And I should see "Test race (12.12.2010 - 13.12.2010, Test town)" in the email body
    And I should see "Siirry syöttämään kilpailijoita:" in the email body
    When I click the first link in the email
    Then I should be on the login page
    When I fill in "another@official.com" for "Sähköposti"
    And I fill in "pword123" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the limited official competitors page for "Test race"

  @javascript
  Scenario: Invite official with limited rights to certain club
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword123"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And the race has a club "Club 1"
    And the race has a club "Club 2"
    And I have logged in
    And I am on the invite officials page for "Test race"
    When I check "Anna käyttäjälle ainoastaan oikeudet lisätä kilpailijoita"
    And I fill in "another@official.com" for "Sähköposti"
    And I select "Club 2" from "Salli kilpailijoiden lisäys vain tiettyyn piiriin/seuraan"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi rajoitetuin oikeuksin" in a success message
    And current officials card 1 should contain "Official Another" with limited rights to club "Club 2"

  @javascript
  Scenario: If no clubs, official sees explicitly that club limitation cannot be used
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword123"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the invite officials page for "Test race"
    When I check "Anna käyttäjälle ainoastaan oikeudet lisätä kilpailijoita"
    Then I should see "(Käyttöä ei voi rajata, koska yhtään piiriä/seuraa ei ole lisätty.)"
    When I follow "yhtään piiriä/seuraa ei ole lisätty"
    Then the "Seurat" sub menu item should be selected
    And I should be on the official clubs page for "Test race"

  @javascript
  Scenario: Invite official with limited rights but rights to add new clubs
    Given there is an official "Another" "Official" with email "another@official.com" and password "pword123"
    And I am an official "Tim Thomas" with email "tim@official.com"
    And I have a race "Test race"
    And I have logged in
    And I am on the invite officials page for "Test race"
    When I check "Anna käyttäjälle ainoastaan oikeudet lisätä kilpailijoita"
    And I fill in "another@official.com" for "Sähköposti"
    And I check "Salli uusien piirien/seurojen lisäys"
    And I press "Lähetä kutsu"
    Then I should see "Toimitsija Another Official lisätty kilpailun Test race toimitsijaksi rajoitetuin oikeuksin" in a success message
    And current officials card 1 should contain "Official Another" with limited rights to club "Lisäys sallittu"

  Scenario: Official cannot delete herself from the race
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And I am on the invite officials page for "Test race"
    Then I should not see "Peruuta kutsu"

  Scenario: Primary official cannot be deleted from the race
    Given I am an official
    And I have a race "Test race"
    And I have logged in
    And there exists an official "Pekka Päätoimitsija" with email "primary@test.com"
    And "primary@test.com" is the primary official for the race
    And I am on the invite officials page for "Test race"
    Then I should not see "Peruuta kutsu"

  Scenario: Official can cancel sent invitation
    Given there is an official "Another" "Official"
    And I am an official
    And I have a race "Test race"
    And I have invited "Another" "Official" to the race
    And I have logged in
    And I am on the invite officials page for "Test race"
    Then current officials card 1 should contain "Official Another" with full rights
    When I follow "Peruuta kutsu"
    Then I should be on the invite officials page for "Test race"
    And I should see "Another Official ei ole enää kilpailun toimitsija" in a success message
    And the current officials table should not contain "Another Official"
