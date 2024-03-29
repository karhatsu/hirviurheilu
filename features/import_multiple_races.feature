Feature: Import multiple races with CSV file
  In order to get all the races of the season easily to the database
  As a district official
  I want to import an CSV file that contains the data for the races

  @javascript
  Scenario: Try to import invalid file, import valid file and try to import valid file again
    Given there is a district "Pohjois-Savo" with short name "PS"
    And there is an official with email "toimitsija.1@testi.com"
    And there is an official with email "toimitsija.2@testi.com"
    And I am an official
    And I have logged in
    And I am on the official index page
    And I follow "Lisää monta kilpailua"
    Then the official main menu item should be selected
    And the page title should contain "Usean kilpailun lisäys"
    When I press "Tallenna kilpailut palveluun"
    Then I should see "Valitse tiedosto" in an error message
    When I attach the import test file "import_multiple_races_invalid.csv" to "CSV-tiedosto"
    And I press "Tallenna kilpailut palveluun"
    Then I should see "Kilpailuiden tallennus epäonnistui" in an error message
    And I should see "Rivi 3: Piiri on virheellinen, Alkupvm on pakollinen, Taso on virheellinen" in an error message
    When I attach the import test file "import_multiple_races.csv" to "CSV-tiedosto"
    And I press "Tallenna kilpailut palveluun"
    Then I should be on the official index page
    And I should see "Kilpailut (3) tallennettu palveluun" in a success message
    And I should see "Metsästysluodikon pm-kisat"
    And I should see "Testiseuran mestaruuskisat"
    And "toimitsija.1@testi.com" should receive an email with subject "Hirviurheilu - sinulle on lisätty kilpailuja"
    And "uusi@toimitsija.com" should receive an email with subject "Hirviurheilu - sinulle on lisätty kilpailuja"
    When "toimitsija.1@testi.com" opens the email
    Then I should see "Metsästysluodikon pm-kisat" in the email body
    And I should see "Löydät kilpailut Hirviurheilusta Toimitsijan sivuilta." in the email body
    When "uusi@toimitsija.com" opens the email
    Then I should see "Ilmahirven seurakilpailut" in the email body
    And I should see "Rekisteröidy Hirviurheiluun, niin pääset hallinnoimaan kilpailuja." in the email body
    When I follow "Lisää monta kilpailua"
    And I attach the import test file "import_multiple_races.csv" to "CSV-tiedosto"
    And I press "Tallenna kilpailut palveluun"
    Then I should see "Rivi 2: Järjestelmästä löytyy jo kilpailu, jolla on sama laji, nimi, sijainti ja päivämäärä" in an error message
    When I choose "Toimitsijan sivut" from main menu
    And I follow "Ilmahirven seurakilpailut"
    And I choose "Toimitsijat" from sub menu
    Then I should see "Odottaa rekisteröitymistä"
    And I should see "uusi@toimitsija.com"
    When I choose "Toimitsijan sivut" from main menu
    And I follow "Metsästysluodikon pm-kisat"
    And I choose "Toimitsijat" from sub menu
    Then I should not see "Odottaa rekisteröitymistä"
