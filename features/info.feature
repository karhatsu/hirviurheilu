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
    And I should see /Ota yhteyttä/ within "h2"
    And I should see /Kysymyksiä ja vastauksia/ within "h2"
    And I should see /Kilpailumuodot/ within "h2"
    And I should see /Ohjevideo/ within "h2"
    And I should see /Palvelun toimittaja/ within ".company_contact"
    And I should see /Karhatsu IT Consulting Oy/ within ".company_contact"
    When I follow "Lähetä palautetta järjestelmän kautta"
    Then I should be on the send feedback page
