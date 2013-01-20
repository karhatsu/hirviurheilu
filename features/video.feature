Feature: Video with live results
  In order to get better race following experience
  As a user
  I want to watch live video from the race
  
  Scenario: No video defined
    Given there is a race "No video race"
    And I am on the race page of "No video race"
    Then I should not see "Video"
    
  Scenario: Video defined
    Given there is a race "Video race"
    And the admin has defined video source "<b>Live stream</b>" with description "Great experience!" for the race
    And I am on the race page of "Video race"
    When I follow "Video"
    Then I should be on the video page of race "Video race"
    And the "Kilpailut" main menu item should be selected
    And the "Video" sub menu item should be selected
    And I should see "Great experience!"
    And I should see "Live stream"
    But I should not see "<b>Live stream</b>"
    