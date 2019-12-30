Feature: Age group selection
  In order to get correct results for all competitors
  As an official
  I want to select age groups for the competitors

  @javascript
  Scenario: Age group selection in competitor add and edit
    Given I am an official for the race "Ikäkisa"
    And the race has series "M"
    And the race has series "M60"
    And the series has an age group "M65"
    And the race has series "S15"
    And the series has an age group "T15"
    And the series has an age group "P15"
    And I have logged in
    And I am on the new competitor page of the series "S15"
    Then the age group menu should not be hidden
    And the age group menu should contain items "P15,T15"
    When I select "M" from "Sarja"
    Then the age group menu should be hidden
    When I select "M60" from "Sarja"
    Then the age group menu should not be hidden
    And the age group menu should contain items "M60,M65"
    When I select "M65" from "Ikäryhmä"
    And I fill in "Matti" for "Etunimi"
    And I fill in "Majala" for "Sukunimi"
    And I fill in "Testiseura" for "club_name"
    And I press "Tallenna"
    When I follow "Takaisin sarjan M60 kilpailijaluetteloon"
    Then I should see "M60 - Kilpailijat"
    When I follow "Majala Matti"
    Then the age group menu should not be hidden
    And "M65" should be selected in the age group menu

  @javascript
  Scenario: Age group selection in limited official competitors page
    Given I am a limited official for the race "Ikäkisa"
    And the race has a club "Test club"
    And the race has series "M"
    And the race has series "M60"
    And the series has an age group "M65"
    And the race has series "S15"
    And the series has an age group "T15"
    And the series has an age group "P15"
    And I have logged in
    And I am on the limited official competitors page for "Ikäkisa"
    Then the age group menu should be hidden
    When I select "M60" from "Sarja"
    Then the age group menu should not be hidden
    And the age group menu should contain items "M60,M65"
    When I select "S15" from "Sarja"
    Then the age group menu should contain items "P15,T15"
    When I select "P15" from "Ikäryhmä"
    And I press "Tallenna"
    Then I should see "Etunimi on pakollinen" in an error message
    And "P15" should be selected in the age group menu
    When I fill in "Matti" for "Etunimi"
    And I fill in "Majala" for "Sukunimi"
    And I press "Tallenna"
    Then I should be on the limited official competitors page for "Ikäkisa"
    And "S15" should be selected in the series menu
    And "P15" should be selected in the age group menu
    When I follow "Muokkaa"
    Then the age group menu should not be hidden
    And "P15" should be selected in the age group menu
