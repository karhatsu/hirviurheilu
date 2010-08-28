Feature: Main page
  In order to start using the service
  As a user
  I want to access the service main page

  Scenario: Load main page
    Given I go to the home page
    Then I should see "Hirvenhiihdon ja hirvenjuoksun tulospalvelu" within "h1"

