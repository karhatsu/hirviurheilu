Feature: Account
  In order to keep my account up-to-date
  As an official
  I want to update my account and change password

  Scenario: Update account information
    Given I am an official with email "test@test.com" and password "test1234"
    And I have logged in
    When I follow "Omat tiedot"
    Then I should see "test@test.com"
    But I should not see "test1234"
    When I follow "Muokkaa tietoja"
    And I fill in "" for "Etunimi"
    And I press "Päivitä"
    Then I should see "Etunimi on pakollinen" in an error message
    When I fill in the following:
      | Etunimi | Teppo |
      | Sukunimi | Testaaja |
      | Seura | Tepon ampumaseura |
      | Sähköposti | teppo@test.com |
    And I fill in "Teppo" for "Etunimi"
    And I fill in "Testaaja" for "Sukunimi"
    And I fill in "Tepon ampumaseura" for "Seura"
    And I fill in "teppo@test.com" for "Sähköposti"
    And I press "Päivitä"
    Then I should see "Käyttäjätili päivitetty" in a success message
    And I should see "Teppo"
    And I should see "Testaaja"
    And I should see "Tepon ampumaseura"
    And I should see "teppo@test.com"

  Scenario: Change password
    Given I am an official with email "test@test.com" and password "test1234"
    And I have logged in
    When I follow "Omat tiedot"
    And I follow "Vaihda salasana"
    When I fill in the following:
      | Uusi salasana | new-password |
      | Salasana uudestaan | different-password |
    And I press "Tallenna"
    Then I should see "Salasana uudestaan ei vastaa varmennusta" in an error message
    When I fill in the following:
      | Uusi salasana | new-password |
      | Salasana uudestaan | new-password |
    And I press "Tallenna"
    Then I should see "Salasana vaihdettu" in a success message
    When I follow "Kirjaudu ulos"
    And I follow "Aloita"
    And I follow "Kirjaudu sisään"
    And I fill in "test@test.com" for "Sähköposti"
    And I fill in "new-password" for "Salasana"
    And I press "Kirjaudu"
    Then I should see "Omat tiedot"
