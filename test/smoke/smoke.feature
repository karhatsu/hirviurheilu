Feature: Smoke
  In order to feel good after deployment
  As a developer
  I want to quickly check that the site is working

  @javascript
  Scenario: Test main pages
    Given I open the smoke test domain
    Then the page title should contain "Hirviurheilu - Tulospalvelu Metsästäjäliiton urheilulajeille"
    When I follow "Etsi kilpailu"
    Then the page title should contain "Hirviurheilu - Kilpailut"
    When I click the card 1
    Then I should see "Kilpailun etusivu"
