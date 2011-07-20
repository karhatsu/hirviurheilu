Feature: Manage team competitions
  In order to have team competition results calculated
  As an official
  I want to manage team competitions

  Scenario: Create and modify team competition
    Given I am an official
    And I have a race "Team race"
    And the race has series "First series"
    And the race has series "Seconds series"
    And the series has an age group "Age group 1"
    And the series has an age group "Age group 2"
    And I have logged in
    And I am on the official race page of "Team race"
    When I follow "Joukkuekilpailut"
    Then the official main menu item should be selected
    And the "Joukkuek." sub menu item should be selected
    And I should see "Joukkuekilpailut" within "h2"
    When I follow "Lisää joukkuekilpailu"
    Then the official main menu item should be selected
    And the "Joukkuek." sub menu item should be selected
    And I should see "Uusi joukkuekilpailu" within "h2"
    And I should see "Valitse kaikki sarjat ja ikäryhmät, jotka kuuluvat tähän joukkuekilpailuun." within "div.info"
    When I press "Tallenna"
    Then I should see "Kilpailun nimi on pakollinen" within "div.error"
    When I fill in "My team competition" for "Kilpailun nimi"
    And I fill in "8" for "Kilpailijoita / joukkue"
    And I check "First series"
    And I check "Age group 2"
    And I press "Tallenna"
    Then I should be on the official team competitions page of "Team race"
    And I should see "Joukkuekilpailu luotu" within "div.success"
    And I should see "My team competition"
    And I should see "8"
    And I should see "First series, Age group 2"
    When I follow "My team competition"
    Then the official main menu item should be selected
    And the "Joukkuek." sub menu item should be selected
    And I should see "Muokkaa joukkuekilpailun tietoja" within "h2"
    When I fill in "Modified name" for "Kilpailun nimi"
    And I fill in "7" for "Kilpailijoita / joukkue"
    And I uncheck "First series"
    And I check "Age group 1"
    And I press "Tallenna"
    Then I should be on the official team competitions page of "Team race"
    And I should see "Joukkuekilpailun tiedot päivitetty" within "div.success"
    And I should see "Modified name"
    And I should see "7"
    And I should see "Age group 1" within "div.main_content"
    And I should see "Age group 2" within "div.main_content"
    But I should not see "First series" within "div.main_content"
