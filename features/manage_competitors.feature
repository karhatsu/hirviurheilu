Feature: Manage competitors
  In order to be able to create start lists for my race
  As an official
  I want to add and edit competitors

  Scenario: When race has series but no competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    When I go to the official index page
    And I follow "Test race"
    Then I should see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa. Aloita klikkaamalla sarjan nimen vieressä olevaa linkkiä." within "div.notice"
    When I go to the official competitors page of the series
    Then I should see "Et ole syöttänyt tähän sarjaan vielä yhtään kilpailijaa." within "div.notice"
    When I follow "Lisää kilpailija" within "div.main"
    Then I should be on the new competitor page of the series

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
    And I press "Tallenna ja palaa kilpailijalistaan"
    Then I should be on the official competitors page of the series
    And I should see "Stevensson Tom"
    And I should see "Shooting club"
    And I should see "Heyton Math"
    And I should see "Sports club"
    And I should see "Kun olet syöttänyt sarjaan kaikki kilpailijat, lisää heille alla olevan linkin avulla lähtöajat- ja numerot." within "div.notice"
    When I follow "Lähtöaikojen ja -numeroiden luonti..."
    Then I should be on the official start list page of the series
    When I go to the official race page of "Test race"
    Then I should not see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa."

  Scenario: Edit competitor before and after start list is created
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-23 |
    And the race has series with attributes:
      | name | Test series |
      | first_number | 10 |
      | start_time | 2010-11-23 11:00 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And I have logged in
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    Then I should not see "Saapumisaika"
    And I should not see "Ammunta yhteensä"
    And I should not see "Arvio 1"
    When I fill in "Peter" for "Etunimi"
    And I fill in "Ford" for "Sukunimi"
    And I press "Tallenna ja palaa listaan"
    Then I should be on the official competitors page of the series
    And I should see "Ford Peter" within "tr#competitor_1"
    When the start list has been generated for the series
    And I follow "Ford Peter"
    Then I should see "Saapumisaika"
    And I should see "Ammunta yhteensä"
    And I should see "Arvio 1"
