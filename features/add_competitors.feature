Feature: Add competitors
  In order to be able to create start lists for my race
  As an official
  I want to add competitors

  Scenario: Official race main page when race has series but no competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    When I go to the official index page
    And I follow "Test race"
    Then I should see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa. Aloita klikkaamalla sarjan nimen vieressä olevaa linkkiä." within "div.notice"

  Scenario: Add competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And the race has a club "Shooting club"
    And the race has a club "Sports club"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Lisää kilpailija"
    And I fill in the following:
      | Etunimi | Tom |
      | Sukunimi | Stevensson |
    And I select "Shooting club" from "club"
    And I press "Tallenna ja lisää toinen kilpailija"
    Then I should see "Kilpailija lisätty"
    And the "Etunimi" field should not contain "Tom"
    When I fill in the following:
      | Etunimi | Math |
      | Sukunimi | Heyton |
    And I select "Sports club" from "club"
    And I press "Tallenna ja palaa sarjan tietoihin"
    Then I should be on the edit page of "Test series"
    And I should see "Stevensson Tom"
    And I should see "Shooting club"
    And I should see "Heyton Math"
    And I should see "Sports club"
    When I go to the official race page of "Test race"
    Then I should not see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa."