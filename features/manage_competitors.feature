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
    Then I should see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa. Aloita klikkaamalla sarjan nimen vieressä olevaa linkkiä." within "div.info"
    When I go to the official competitors page of the series
    Then I should see "Et ole syöttänyt tähän sarjaan vielä yhtään kilpailijaa." within "div.info"
    When I follow "Lisää kilpailija" within "div.main_content"
    Then I should be on the new competitor page of the series

  Scenario: Edit competitor before and after start list is created
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_date | 2010-11-23 |
    And the race has series with attributes:
      | name | Test series |
      | first_number | 10 |
      | start_time | 11:00 |
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
    When I fill in "95" for "Ammunta yhteensä"
    And I fill in "11" for "competitor_arrival_time_4i"
    And I fill in "35" for "competitor_arrival_time_5i"
    And I fill in "23" for "competitor_arrival_time_6i"
    And I fill in "120" for "Arvio 1"
    And I fill in "100" for "Arvio 2"
    And I press "Tallenna ja palaa listaan"
    Then I should be on the official competitors page of the series
    And I should see "" within "tr#competitor_1 img"
    
  Scenario: Updating competitor before results should not create additional shots
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | first_number | 10 |
      | start_time | 11:00 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
    And the start list has been generated for the series
    And I have logged in
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I press "Tallenna ja palaa listaan"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I follow "Johnson James"
    Then I should not see "0,0,0,0,0,0,0,0,0,0"
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I fill in the following:
      | competitor_shots_attributes_new_0_shots_value | 10 |
      | competitor_shots_attributes_new_1_shots_value | 10 |
      | competitor_shots_attributes_new_2_shots_value | 10 |
      | competitor_shots_attributes_new_3_shots_value | 10 |
      | competitor_shots_attributes_new_4_shots_value | 10 |
      | competitor_shots_attributes_new_5_shots_value | 9 |
      | competitor_shots_attributes_new_6_shots_value | 9 |
      | competitor_shots_attributes_new_7_shots_value | 9 |
      | competitor_shots_attributes_new_8_shots_value | 8 |
    And I press "Tallenna ja palaa listaan"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I follow "Johnson James"
    Then I should see "10,10,10,10,10,9,9,9,8,0"
