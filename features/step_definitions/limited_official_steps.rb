Given /^I am a limited official for the race "(.*?)"$/ do |race_name|
  steps %Q{
    Given I am an official
    And there is a race "#{race_name}"
    And I have only add competitors rights for the race
  }
end
