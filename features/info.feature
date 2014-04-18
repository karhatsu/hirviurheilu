Feature: Info page
  In order to understand better what Hirviurheilu is all about
  As a potential user
  I want to read information from the Info page

  Scenario: Info page
    Given I am on the home page
    And I follow "Info"
    Then I should be on the info page
    And the "Info" main menu item should be selected
    And the page title should contain "Tietoa Hirviurheilusta"
    And I should see /Palvelun tarjoaa/ within ".company_contact"
    And I should see /Karhatsu IT Consulting Oy/ within ".company_contact"
    When I follow "Lähetä palautetta" within ".main_content"
    Then I should be on the send feedback page

  Scenario: Unauthenticated user goes to info page
    Given I am on the info page
    When I follow "Aloita palvelun käyttö"
    Then I should be on the register page
    
  Scenario: Authenticated user goes to info page
    Given I am an official
    And I have logged in
    And I am on the info page
    Then I should not see "Aloita palvelun käyttö"
    When I follow "Siirry Toimitsijan sivuille"
    Then I should be on the official index page
    