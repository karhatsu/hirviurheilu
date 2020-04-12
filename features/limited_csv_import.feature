Feature: Limited CSV import
  In order to be efficient in adding competitors
  As a race official with limited rights
  I want to add competitors from CSV file

  Scenario: Official with limited rights imports competitors from several clubs
    Given I am a limited official for the race "Limited race"
    And the race has series "N"
    And the series has an age group "N50"
    And the race has series "M40"
    And the race has series "S17"
    And the series has an age group "P17"
    And the race has a club "SS"
    And the race has a club "PS"
    And I have logged in
    And I am on the limited official competitors page for "Limited race"
    When I follow "Lisää monta kilpailijaa"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should see "Valitse tiedosto" in an error message
    When I attach the import test file "import_with_invalid_structure.csv" to "CSV-tiedosto"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should see "Virheellinen rivi tiedostossa" in an error message
    When I attach the import test file "import_valid.csv" to "CSV-tiedosto"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should see "Kilpailijat ladattu tietokantaan" in a success message
    And I should be on the limited official competitors page for "Limited race"
    And I should see "Lisätyt kilpailijat (5)"
    And I should see "Hämäläinen Minna"

  Scenario: Official with limited rights to one club imports competitors
    Given there is a race "Limited race"
    And the race has a club "SS"
    And the race has a club "PS"
    And I have limited rights to add competitors to the club "SS" in the race
    And the race has series "N"
    And the series has an age group "N50"
    And the race has series "M40"
    And I have logged in
    And I am on the limited official competitors page for "Limited race"
    When I follow "Lisää monta kilpailijaa"
    When I attach the import test file "import_valid.csv" to "CSV-tiedosto"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should see "Sinulla on oikeus lisätä kilpailijoita vain "SS"-piiriin" in an error message
    When I attach the import test file "import_valid_limited_club.csv" to "CSV-tiedosto"
    And I press "Lataa kilpailijat tietokantaan"
    Then I should see "Kilpailijat ladattu tietokantaan" in a success message
    And I should be on the limited official competitors page for "Limited race"
    And I should see "Lisätyt kilpailijat (3)"
