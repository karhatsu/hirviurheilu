Feature: Admin adds users
  In order to make it easy to start using Hirviurheilu
  As an admin
  I want to add new users

  Scenario: Admin adds new user
    Given I am an admin
    And I have logged in
    And I am on the admin index page
    When I follow the first "Lisää käyttäjä" link
    Then I should be on the admin new user page
    And the "Admin" main menu item should be selected
    And the "Lisää käyttäjä" sub menu item should be selected
    When I fill in "Mikko" for "Etunimi"
    And I fill in "Mäkelä" for "Sukunimi"
    And I fill in "Testiseura" for "Seura"
    And I fill in "mikko@test.com" for "Sähköposti"
    And I fill in "mikkosala" for "Salasana"
    And I press "Lisää käyttäjä"
    Then I should be on the admin users page
    And I should see "Käyttäjä lisätty" in a success message
    And "mikko@test.com" should receive an email with subject "Tunnukset Hirviurheilu-palveluun"
    When I logout
    And "mikko@test.com" opens the email
    Then I should see "Hei Mikko Mäkelä" in the email body
    And I should see "Sinulle on luotu käyttäjätunnus Hirviurheilu-palveluun." in the email body
    And I should see "Sähköposti: mikko@test.com" in the email body
    And I should see "Salasana: mikkosala" in the email body
    When I click the first link in the email
    Then I should be on the login page
    When I fill in "mikko@test.com" for "Sähköposti"
    And I fill in "mikkosala" for "Salasana"
    And I press "Kirjaudu"
    Then I should be on the root page
    When I follow "Toimitsijan sivut"
    Then I should be on the official index page
