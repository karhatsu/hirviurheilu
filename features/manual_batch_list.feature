Feature: Manual batch list
  In order to effectively create a batch list in a small shooting race
  As an official
  I want to manually define batches and competitors in them

  Scenario: Create, edit and delete a batch list
    Given I am an official
    And I have a shooting race "Shooting race"
    And I have logged in
    And I am on the official race page of "Shooting race"
    When I choose "Erät" from sub menu
    Then the official main menu item should be selected
    And the "Erät" sub menu item should be selected
    When I follow "Lisää erä"
    Then the "Erät" sub menu item should be selected
    And I should see "Lisää erä" within "h2"
    When I fill in "10" for "Numero"
    And I fill in "2" for "Rata"
    And I select "11" from "batch_time_4i"
    And I select "30" from "batch_time_5i"
    And I press "Tallenna"
    Then I should see "Erät" within "h2"
    And I should see "Erä lisätty" in a success message
    And I should see "10" within ".card__number"
    And I should see "11:30 (Rata 2)" within ".card__name"
    When I follow "11:30 (Rata 2)"
    And I fill in "33" for "Numero"
    And I fill in "1" for "Rata"
    And I select "15" from "batch_time_4i"
    And I select "25" from "batch_time_5i"
    And I press "Tallenna"
    Then I should see "Erä päivitetty" in a success message
    And I should see "33" within ".card__number"
    And I should see "15:25 (Rata 1)" within ".card__name"
    When I follow "15:25 (Rata 1)"
    And I follow "Poista erä"
    Then I should see "Erät" within "h2"
    And I should see "Erä poistettu" in a success message
    But I should not see "11:30 (Rata 2)"
