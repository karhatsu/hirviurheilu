Feature: Search races
  In order to find the race I am interested in
  As a user
  I want to search races

  Scenario: Search races
    Given there is a "ILMAHIRVI" race "Race A" at "2020-04-01" in "Uusimaa"
    And there is a "RUN" race "Race B" at "2020-04-02" in "Uusimaa"
    And there is a "SKI" race "Race C" at "2020-03-31" in "Lappi"
    And there is a "ILMAHIRVI" race "Race D" at "2020-04-03" in "Kainuu"
    And there is a "ILMAHIRVI" race "Race E" at "2020-04-04" in "Kainuu"
    And I am on the races page
    Then I should see 5 races ordered as "Race E, Race D, Race B, Race A, Race C"
    When I select "Ilmahirvi" from "sport_key"
    And I press "Etsi"
    Then I should see 3 races ordered as "Race E, Race D, Race A"
    When I select "Kainuu" from "district_id"
    And I press "Etsi"
    Then I should see 2 races ordered as "Race E, Race D"
    When I fill in "D" for "search_text"
    And I press "Etsi"
    Then I should see 1 races ordered as "Race D"
    When I follow "Tyhjennä"
    Then I should see 5 races ordered as "Race E, Race D, Race B, Race A, Race C"
