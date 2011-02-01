Feature: Publish race
  In order to let the competitors and anyone who is interested to see the race results
  As a person using the software offline
  I want to publish the finished race to an online service

  Scenario: No publishing in online
    Given I am an official
    And I have an ongoing race "Online race"
    And I have logged in
    And I am on the official race page of "Online race"
    Then I should not see "Julkaise"
    When I go to the publish race page of "Online race"
    Then I should be on the official race page of "Online race"

  Scenario: Unfinished race
    Given I use the software offline
    And I have an ongoing race "Online race"
    And I am on the official race page of "Online race"
    And I follow "Julkaise"
    Then I should see "Online race" within "div.main_title"
    And I should see "Julkaise kilpailu internetissä" within "h2"
    And I should see "Tällä sivulla voit julkaista kilpailun lopulliset tulokset internetissä. Tarvitset vain tunnukset Hirviurheilu-palveluun (http://www.hirviurheilu.com). Julkaiseminen ei maksa mitään." within "div.info"
    And I should see "Voit julkaista kilpailun vasta, kun olet merkinnyt sen päättyneeksi." within "div.error"
