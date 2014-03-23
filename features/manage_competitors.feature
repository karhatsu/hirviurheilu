Feature: Manage competitors
  In order to be able to create start lists for my race
  As an official
  I want to add and edit competitors
  
  Scenario: When competitors' start order is mainly by series default way to add competitors is from the add competitor page
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_order | 1 |
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Lisää tämän sarjan ensimmäinen kilpailija"
    Then I should be on the new competitor page of the series
  
  Scenario: When competitors' start order is mixed default way to add competitors is from the start list page
    Given I am an official
    And I have a race with attributes:
      | name | Test race |
      | start_order | 2 |
    And the race has series "Test series"
    And I have logged in
    And I am on the official race page of "Test race"
    When I follow "Lisää tämän sarjan ensimmäinen kilpailija"
    Then I should be on the official start list page of the race "Test race"

  Scenario: When race has series but no competitors
    Given I am an official
    And I have a race "Test race"
    And the race has series with attributes:
      | name | Test series |
    And I have logged in
    When I go to the official index page
    And I follow "Test race"
    Then I should see "Et ole syöttänyt sarjoihin vielä yhtään kilpailijaa. Aloita klikkaamalla sarjan nimen vieressä olevaa linkkiä." in an info message
    When I go to the official competitors page of the series
    Then I should see "Et ole syöttänyt tähän sarjaan vielä yhtään kilpailijaa." in an info message
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
    And I fill in "Testiseura" for "club_name"
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    And I should see "Ford Peter" within "tr#competitor_1"
    When the start list has been generated for the series
    And I follow "Ford Peter"
    Then I should see "Saapumisaika"
    And I should see "Ammunta yhteensä"
    And I should see "Arvio 1"
    When I fill in "95" for "Ammunta yhteensä"
    And I fill in "11:35:23" for "competitor_arrival_time"
    And I fill in "120" for "Arvio 1"
    And I fill in "100" for "Arvio 2"
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    And I should see "" within "tr#competitor_1 img"
    
  Scenario: Updating competitor without shots, adding shots, updating shots
    Given I am an official
    And I have a race "Test race"
    And the race has a club "Testiseura"
    And the race has series with attributes:
      | first_number | 10 |
      | start_time | 11:00 |
    And the series has a competitor with attributes:
      | first_name | James |
      | last_name | Johnson |
      | club | Testiseura |
    And the start list has been generated for the series
    And I have logged in
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I press "Tallenna"
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
      | competitor_shots_attributes_new_9_shots_value | 0 |
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I follow "Johnson James"
    Then I should see "10,10,10,10,10,9,9,9,8,0"
    When I go to the official competitors page of the series
    And I follow "Johnson James"
    And I fill in the following:
      | competitor_shots_attributes_3_value | 5 |
      | competitor_shots_attributes_9_value | 7 |
    And I press "Tallenna"
    Then I should be on the official competitors page of the series
    When I go to the results page of the series
    And I follow "Johnson James"
    Then I should see "10,10,10,10,9,9,9,8,7,5"
