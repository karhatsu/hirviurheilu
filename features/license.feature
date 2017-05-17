Feature: License
  In order to be able to use my offline product with full power
  As an offline product user
  I want to see my activation key in the online service

  Scenario: When user has already checked the activation key, just ask password
    Given I am an official "Mathew Stevensson" with email "license@hirviurheilu.com" and password "license1"
    And I have already opened the activation key with invoicing info "Laskutusseura"
    And I have logged in
    And I change my password to "new-password"
    When I go to the activation key page
    And I fill in "new-password" for "Salasana"
    And I press "Näytä aktivointitunnus"
    Then I should see "Aktivointitunnus: 3DD4C0AA32" in a success message
    And the admin should receive no emails

  Scenario: Unauthenticated user wants to see activation key
    Given I go to the activation key page
    Then I should be on the login page

  Scenario: Staging environment user tries to see activation key
    Given I use the service in the staging environment
    And I am an official
    And I have logged in
    And I go to the activation key page
    Then I should see "Voit hankkia aktivointitunnuksen vain varsinaisesta Hirviurheilu Online -palvelusta." in an error message
    But I should not see "Salasana"
    And I should not see "Hyväksyn käyttöehdot"

  Scenario: User tries to access license page in online mode
    Given I go to the new license page
    Then I should be on the home page
