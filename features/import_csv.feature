Feature: Import competitors with CSV file
  In order to get the new competitors easily to the database
  As an official
  I want to import an CSV file that contains the necessary competitor information
  
  Scenario: Import valid CSV file
    Given I am an official
    And I have a race "CSV race"
    And the race has series "N"
    And the series has an age group "N50"
    And the race has series "M40"
    And I have logged in
    And I am on the official race page of "CSV race"
    When I follow "Lisää kilpailijoita CSV-tiedostosta"
    Then the official main menu item should be selected
    And the page title should contain "CSV race"
    And I should see "Lisää kilpailijoita CSV-tiedostosta" within "h2"
    And I should see "Jos sinulla on kilpailijoiden tiedot" in an info message
    When I press "Lataa kilpailijat tietokantaan"
    Then I should see "Valitse tiedosto" in an error message
    When I attach the import test file "import_valid.csv" to "CSV-tiedosto"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should be on the official race page of "CSV race"
    And I should see "Kilpailijat ladattu tietokantaan" in a success message
    When I follow "Kilpailijat"
    Then I should see "Räsänen Heikki"
    When I follow "N" within "div.sub_sub_menu"
    Then I should see "Miettinen Minna"
    
  Scenario: Trying to import an invalid CSV file (series missing)
    Given I am an official
    And I have a race "CSV race"
    And the race has series "M40"
    And I have logged in
    And I am on the official race page of "CSV race"
    When I follow "Lisää kilpailijoita CSV-tiedostosta"
    And I attach the import test file "import_valid.csv" to "CSV-tiedosto"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should see "Tuntematon sarja/ikäryhmä: 'N'" in an error message
    And I should see "Lisää kilpailijoita CSV-tiedostosta" within "h2"
    