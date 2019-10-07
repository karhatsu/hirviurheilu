Feature: Manage cup
  In order to calculate cup results
  As an official
  I want to add and modify cups

  Scenario: Try to add cup when not enough races
    Given I am an official
    And I have a race "Only one race"
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi cup-kilpailu"
    Then I should be on the new official cup page
    And the official main menu item should be selected
    And the page title should contain "Cup-kilpailun lisäys"
    But I should see "Sinulla täytyy olla vähintään 2 kilpailua ennen kuin voit lisätä cup-kilpailun" in an info message

  Scenario: Add cup
    Given I am an official "Teppo Testaaja"
    And I have a race "My race 1"
    And the race has series "M50"
    And the race has series "M60"
    And I have a race "My race 2"
    And the race has series "M70"
    And I have a race "My race 3"
    And I have logged in
    When I go to the new official cup page
    Then I should not see "Sinulla täytyy olla vähintään"
    When I fill in the following:
      | Cup-kilpailun nimi | Test cup |
      | Yhteistulokseen laskettavien kilpailuiden määrä | 2 |
    And I check "race_id_0"
    And I check "race_id_2"
    And I press "Lisää cup-kilpailu"
    Then I should be on the official cup page of "Test cup"
    And I should see "Cup-kilpailu lisätty" in a success message
    And the page title should contain "Test cup"
    And I should see "Yhteistulokseen laskettavien kilpailuiden määrä: 2"
    And I should see "My race 1"
    And I should see "My race 3"
    But I should not see "My race 2"
    And I should see "Cup-sarjat"
    And I should see "M50"
    And I should see "M60"
    But I should not see "M70"
    When I follow "Takaisin Toimitsijan etusivulle"
    And I follow "Test cup"
    Then I should be on the official cup page of "Test cup"

  Scenario: Invalid basic data when adding cup
    Given I am an official
    And I have a race "My race 1"
    And I have a race "My race 2"
    And I have logged in
    And I am on the new official cup page
    When I fill in the following:
      | Yhteistulokseen laskettavien kilpailuiden määrä | 2 |
    And I check "race_id_0"
    And I check "race_id_1"
    And I press "Lisää cup-kilpailu"
    Then the page title should contain "Cup-kilpailun lisäys"
    And I should see "Cup-kilpailun nimi on pakollinen" in an error message

  Scenario: Choose wrong amount of races for the cup
    Given I am an official
    And I have a race "My race 1"
    And I have a race "My race 2"
    And I have a race "My race 3"
    And I have logged in
    And I am on the new official cup page
    When I fill in the following:
      | Cup-kilpailun nimi | Test cup |
      | Yhteistulokseen laskettavien kilpailuiden määrä | 2 |
    And I check "race_id_0"
    And I press "Lisää cup-kilpailu"
    Then I should see error about too few races selected for the cup
    And the "race_id_0" checkbox should be checked
    When I check "race_id_0"
    And I check "race_id_1"
    And I check "race_id_2"
    And I fill in "4" for "Yhteistulokseen laskettavien kilpailuiden määrä"
    And I press "Lisää cup-kilpailu"
    Then I should see error about too few races selected for the cup

  Scenario: Modify cup
    Given I am an official
    And I have a cup "My cup" with 2 top competitions
    And I have a race "My race 1"
    And the race has series "M50"
    And the race has series "N50"
    And the race belongs to the cup
    And I have a race "My race 2"
    And the race belongs to the cup
    And the cup contains the default cup series
    And I have a race "My race 3"
    And I have a race "My race 4"
    And I have logged in
    And I am on the official cup page of "My cup"
    And I follow "Muokkaa cup-kilpailun asetuksia"
    Then I should see "Muokkaa cup-kilpailun asetuksia" within "h2"
    And the "Cup-kilpailun nimi" field should contain "My cup"
    And the "Yhteistulokseen laskettavien kilpailuiden määrä" field should contain "2"
    And the "race_id_0" checkbox should be checked
    And the "race_id_1" checkbox should be checked
    But the "race_id_2" checkbox should not be checked
    But the "race_id_3" checkbox should not be checked
    And the "cup_cup_series_attributes_0_name" field should contain "M50"
    And the "cup_cup_series_attributes_1_name" field should contain "N50"
    When I fill in the following:
      | Cup-kilpailun nimi | Renamed cup |
      | Yhteistulokseen laskettavien kilpailuiden määrä | 3 |
    And I uncheck "race_id_1"
    And I check "race_id_2"
    And I check "race_id_3"
    And I fill in "M60" for "cup_cup_series_attributes_0_name"
    And I fill in "N" for "cup_cup_series_attributes_1_name"
    And I fill in "N40,N60" for "cup_cup_series_attributes_1_series_names"
    And I press "Päivitä"
    Then I should be on the official cup page of "Renamed cup"
    And I should see "Cup-kilpailu päivitetty" in a success message
    And the page title should contain "Renamed cup"
    And I should see "Yhteistulokseen laskettavien kilpailuiden määrä: 3"
    And I should see "My race 1"
    And I should see "My race 3"
    And I should see "My race 4"
    But I should not see "My race 2"
    And I should see "M60"
    And I should see "N (N40, N60)"
    But I should not see "M50"
    And I should not see "N50"

  Scenario: Error handling when modifying cup
    Given I am an official
    And I have a cup "My cup" with 2 top competitions
    And I have a race "My race 1"
    And the race belongs to the cup
    And I have a race "My race 2"
    And the race belongs to the cup
    And I have logged in
    And I am on the official cup page of "My cup"
    And I follow "Muokkaa cup-kilpailun asetuksia"
    When I fill in "" for "Cup-kilpailun nimi"
    And I press "Päivitä"
    Then I should see "Cup-kilpailun nimi on pakollinen" in an error message
    When I fill in "Renamed cup" for "Cup-kilpailun nimi"
    And I uncheck "race_id_0"
    And I press "Päivitä"
    Then I should see error about too few races selected for the cup
