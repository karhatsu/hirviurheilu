Feature: Announcements
  As a user
  I want to read announcements
  so that I know what's happening in Hirviurheilu

  Scenario: No announcements in offline
    Given I use the software offline
    And I am on the home page
    Then I should not see "Tiedotteet"
    
  Scenario: No announcements added
    Given I am on the home page
    Then I should not see "Tiedotteet"
  
  Scenario: Announcement added by admin can be seen in the home page
    Given I am an admin
    And I have logged in
    And I am on the admin index page
    When I follow "Tiedotteet"
    Then I should be on the admin announcements page
    And the "Admin" main menu item should be selected
    And the "Tiedotteet" sub menu item should be selected
    When I follow "Lisää tiedote"
    Then I should be on the new admin announcement page
    When I fill in "Good news" for "Otsikko"
    And I fill in "More about it" for "Sisältö"
    And I check "Aktiivinen"
    And I press "Tallenna"
    Then I should be on the admin announcements page
    And I should see "Tiedote lisätty" in a success message
    And I should see "Good news" within "#all_news"
    When I follow "Etusivu"
    Then I should see "Tiedotteet"
    And I should see "Good news"
    
  Scenario: Show only active announcements
    Given there is an active announcement "Active announcement"
    And there is a non-active announcement "Non-active announcement"
    And I am on the home page
    Then I should see "Active announcement"
    But I should not see "Non-active announcement"
    
  Scenario: Edit announcement
    Given there is an active announcement "Test announcement"
    And I am an admin
    And I have logged in
    And I am on the admin announcements page
    When I follow "Test announcement"
    And I fill in "New title" for "Otsikko"
    And I press "Tallenna"
    Then I should be on the admin announcements page
    And I should see "Tiedote päivitetty" in a success message
    And I should see "New title" within "#all_news"
    