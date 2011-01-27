Feature: Offline usage
  In order to use the system as smoothly as possible
  As a customer without internet connection
  I want to exclude the irrelevant features

  Scenario: No pricing information
    Given I use the software offline
    When I am on the home page
    Then I should not see "Hinnat"
    When I follow "Info"
    Then I should not see "Hinnoittelu"
