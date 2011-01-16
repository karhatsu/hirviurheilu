Feature: Reset password
  In order to use the system again
  As a person who has forgotten her password
  I want to reset my password

  Scenario: Reset password
    Given I am an official with email "test@test.com" and password "test"
    And I am on the home page
    When I follow "Unohtunut salasana"
    Then I should see "Jos olet unohtanut salasanasi, syötä alla olevaan kenttään sähköpostiosoitteesi." within "div.info"
    When I fill in "test@test.com" for "Sähköposti"
    And I press "Tilaa uusi salasana"
    Then I should see "Sähköpostiisi on lähetetty linkki, jonka avulla voit asettaa uuden salasanan."
    And "test@test.com" should receive an email with subject "Hirviurheilu - salasanan vaihto"
    When I open the email
    Then I should see "Klikkaa alla olevaa linkkiä, niin pääset asettamaan uuden salasanan" in the email body
    When I click the first link in the email
    And I fill in "new-password" for "Uusi salasana"
    And I fill in "new-password" for "Uusi salasana uudestaan"
    And I press "Vaihda salasana"
    Then I should be on the account page
    And I should see "Salasana vaihdettu" within "div.notice"
    When I follow "Kirjaudu ulos"
    And I follow "Kirjaudu sisään"
    And I fill in "test@test.com" for "Sähköposti"
    And I fill in "new-password" for "Salasana"
    And I press "Kirjaudu"
    And I follow "Toimitsijan sivut"
    Then I should be on the official index page

  Scenario: Unknown email
    Given I am on the home page
    When I follow "Unohtunut salasana"
    And I fill in "test@test.com" for "Sähköposti"
    And I press "Tilaa uusi salasana"
    Then I should see "Tuntematon sähköpostiosoite" within "div.error"
    And I should see "Jos olet unohtanut salasanasi, syötä alla olevaan kenttään sähköpostiosoitteesi." within "div.info"
    And "test@test.com" should have no emails

  Scenario: Invalid new password
    Given I am an official with email "test@test.com" and password "test"
    And I am on the home page
    When I follow "Unohtunut salasana"
    When I fill in "test@test.com" for "Sähköposti"
    And I press "Tilaa uusi salasana"
    Then "test@test.com" should receive an email
    When I open the email
    And I click the first link in the email
    And I fill in "" for "Uusi salasana"
    And I fill in "" for "Uusi salasana uudestaan"
    And I press "Vaihda salasana"
    Then I should see "Syötä uusi salasana"
    When I fill in "new-password" for "Uusi salasana"
    And I fill in "different-password" for "Uusi salasana uudestaan"
    And I press "Vaihda salasana"
    Then I should see "Salasana ei vastaa varmennusta." within ".error"

  Scenario: Unknown reset hash
    Given I visit "reset_password/unknown_hash/edit"
    Then I should see "Tuntematon tunnus. Varmista, että selaimen osoiterivillä on täsmälleen se linkki, jonka sait sähköpostiisi." within "div.error"
    But I should not see "Uusi salasana"
