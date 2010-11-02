Feature: Feedback
  In order to tell what I like about the service
  As a client
  I want to send feedback

  Scenario: Send successful feedback
    Given I am on the home page
    When I follow "Lähetä palautetta"
    Then I should be on the send feedback page
    Then I should see "Lähetä palautetta" within "h1"
    When I fill in the following:
      | Palaute    | Hyvä järjestelmä! |
      | Nimi       | Pekka Miettinen   |
      | Sähköposti | pekka@palaute.com |
      | Puhelin    | 123 456           |
    When I press "Lähetä"
    Then I should see "Kiitos palautteesta"
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - palaute" in the email subject
    Then I should see "Hyvä järjestelmä!" in the email body
    And I should see "Nimi: Pekka Miettinen" in the email body
    And I should see "Sähköposti: pekka@palaute.com" in the email body
    And I should see "Puhelin: 123 456" in the email body

  Scenario: Send feedback without text
    Given I am on the send feedback page
    When I fill in the following:
      | Nimi       | Pekka Miettinen   |
      | Sähköposti | pekka@palaute.com |
      | Puhelin    | 123 456           |
    And I press "Lähetä"
    Then I should see "Älä unohda kirjoittaa palautetta" within "div.error"
    And the "Nimi" field should contain "Pekka Miettinen"
    And the "Sähköposti" field should contain "pekka@palaute.com"
    And the "Puhelin" field should contain "123 456"

  Scenario: Logged user and prefilled fields
    Given I am an official with attributes:
      | email      | test@domain.com |
      | first_name | Tina            |
      | last_name  | Tester          |
    And I have logged in
    When I go to the send feedback page
    Then the "Nimi" field should contain "Tina Tester"
    And the "Sähköposti" field should contain "test@domain.com"
