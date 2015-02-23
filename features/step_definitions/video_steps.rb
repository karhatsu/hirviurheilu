Given /^the admin has defined video source "(.*?)" with description "(.*?)" for the race$/ do |source, description|
  steps %Q{
    Given I am an admin
    And I have logged in
    And I am on the admin index page
    And I follow "Kilpailut" within ".sub_menu"
    And I follow "Video"
    Then I should be on the admin video page of the race
    When I fill in "#{source}" for "Lähdekoodi"
    And I fill in "#{description}" for "Kuvaus"
    And I press "Tallenna"
    Then I should see "Kilpailu tallennettu"
    And I should be on the admin races page
  }
end
