Feature: Manage cup
  In order to calculate cup results
  As an official
  I want to add and modify cups
  
  Scenario: Try to add cup when not enough races
    Given I am an official
    And I have logged in
    And I am on the official index page
    When I follow "Lisää uusi cup-kilpailu"
    Then I should be on the new official cup page
    And the official main menu item should be selected
    And I should see "Cup-kilpailun lisäys" within ".main_title"
    But I should see "Sinulla täytyy olla vähintään 2 kilpailua ennen kuin voit lisätä cup-kilpailun" within "div.info"
    Given I have a race "My race"
    When I go to the new official cup page
    Then I should see "Sinulla täytyy olla vähintään 2 kilpailua ennen kuin voit lisätä cup-kilpailun" within "div.info"

  Scenario: Add cup
    Given I am an official "Teppo Testaaja"
    And I have a race "My race 1"
    And I have a race "My race 2"
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
    And I should see "Cup-kilpailu lisätty" within "div.success"
    And I should see "Test cup" within ".main_title"
    And I should see "Yhteistulokseen laskettavien kilpailuiden määrä: 2"
    And I should see "My race 1"
    And I should see "My race 3"
    But I should not see "My race 2"
    And the admin should receive an email
    When I open the email
    Then I should see "Hirviurheilu - uusi cup-kilpailu (test)" in the email subject
    And I should see "Kilpailun nimi: Test cup" in the email body
    And I should see "Toimitsija: Teppo Testaaja" in the email body
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
    Then I should see "Cup-kilpailun lisäys" within ".main_title"
    And I should see "Cup-kilpailun nimi on pakollinen" within "div.error"

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
    Then I should see "Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä" within "div.error"
    And the "race_id_0" checkbox should be checked
    When I check "race_id_0"
    And I check "race_id_1"
    And I check "race_id_2"
    And I fill in "4" for "Yhteistulokseen laskettavien kilpailuiden määrä"
    And I press "Lisää cup-kilpailu"
    Then I should see "Sinun täytyy valita vähintään yhtä monta kilpailua kuin on yhteistulokseen laskettavien kilpailuiden määrä" within "div.error"
