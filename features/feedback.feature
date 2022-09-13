Feature: Feedback
  In order to tell what I like about the service
  As a client
  I want to send feedback

  @javascript
  Scenario: Send successful feedback
    Given I am on the home page
    When I follow "Lähetä palautetta"
    Then I should be on the send feedback page
    Then the page title should contain "Lähetä palautetta"
    When I fill in the following:
      | Palaute    | Hyvä järjestelmä! |
      | Nimi       | Pekka Miettinen   |
      | Sähköposti | pekka@palaute.com |
      | Puhelin    | 123 456           |
      | captcha    | kolme             |
    When I press "Lähetä"
    Then I should see "Tarkastuskysymys meni väärin."
    When I fill in "neljä " for "captcha"
    And I press "Lähetä"
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

  @javascript
  Scenario: Send feedback for the race official
    Given there exists an official "Joku Muu" with email "other@test.com"
    And there exists an official "Petteri Pesonen" with email "petteri@test.com"
    And there is a race with attributes:
      | name       | Hyvä kisa  |
      | start_date | 2030-08-01 |
      | location   | Kisakylä   |
    And "other@test.com" is an official for the race
    And "petteri@test.com" is the primary official for the race
    And I am on the new feedback page
    When I select "Hyvä kisa (01.08.2030, Kisakylä)" from "Palautteen kohde"
    And I fill in "Kilpailijan tiedot väärin, voitko korjata?" for "Palaute"
    And I fill in "Yksi kilpailija" for "Nimi"
    And I fill in "Neljä" for "captcha"
    And I press "Lähetä"
    Then I should see "Kiitos palautteesta"
    And "petteri@test.com" should receive an email with subject "Hirviurheilu - palaute"
    When I open the email
    Then I should see "Kilpailijan tiedot väärin, voitko korjata?" in the email body
    And I should see "Kilpailu: Hyvä kisa (01.08.2030, Kisakylä)" in the email body
    And I should see "Nimi: Yksi kilpailija" in the email body

  @javascript
  Scenario: Send feedback for the race official when the race has no primary official
    Given there exists an official "Secondary Official" with email "secondary@test.com"
    And there is a race with attributes:
      | name       | Good race  |
      | start_date | 2030-08-01 |
      | location   | Location   |
    And "secondary@test.com" is an official for the race
    And I am on the new feedback page
    When I select "Good race (01.08.2030, Location)" from "Palautteen kohde"
    And I fill in "Kilpailijan tiedot väärin, voitko korjata?" for "Palaute"
    And I fill in "Yksi kilpailija" for "Nimi"
    And I fill in "Neljä" for "captcha"
    And I press "Lähetä"
    Then I should see "Kiitos palautteesta"
    And "secondary@test.com" should receive an email with subject "Hirviurheilu - palaute"

  @javascript
  Scenario: Send feedback without email address
    Given I am on the new feedback page
    When I fill in the following:
      | Palaute    | Hyvä järjestelmä! |
      | Nimi       | Pekka Miettinen   |
      | Puhelin    | 123 456           |
      | captcha    | neljä             |
    When I press "Lähetä"
    Then I should see "Kiitos palautteesta"
    And the admin should receive an email
    When I open the email
    Then I should see the email delivered from "noreply@hirviurheilu.com"
    And I should see "Hirviurheilu - palaute" in the email subject
    And I should see "Hyvä järjestelmä!" in the email body
    And I should see "Nimi: Pekka Miettinen" in the email body
    And I should see "Sähköposti: " in the email body
    And I should see "Puhelin: 123 456" in the email body
    And I should see "Ympäristö: test" in the email body

  @javascript
  Scenario: Logged user, prefilled fields and current user info in the email
    Given I am an official with attributes:
      | email      | test@domain.com |
      | first_name | Tina            |
      | last_name  | Tester          |
    And I have logged in
    When I go to the send feedback page
    Then the "Nimi" field should contain "Tina Tester"
    And the "Sähköposti" field should contain "test@domain.com"
    When I fill in the following:
      | Palaute    | Hyvä järjestelmä! |
      | Nimi       | |
      | captcha    | fyra |
    And I fill in " " for "Sähköposti"
    And I press "Lähetä"
    Then I should see "Kiitos palautteesta"
    And the admin should receive an email
    When I open the email
    Then I should see the email delivered from "noreply@hirviurheilu.com"
    And I should see "Hirviurheilu - palaute" in the email subject
    And I should see "Hyvä järjestelmä!" in the email body
    And I should see "Nimi: " in the email body
    And I should see "Sähköposti: " in the email body
    And I should see "Puhelin: " in the email body
    And I should see "Ympäristö: test" in the email body
    And I should see the current user id in the email body
