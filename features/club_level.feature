Feature: Club level
  So that clubs for competitors would be correct
  As a newbie official
  I want to clearly know what to write for the club field

  Scenario: Show "Seura" as default club title
    Given I am an official
    And I have logged in
    And I am on the new official race page
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
    And I select "Test district" from "race_district_id"
    And I choose "Pääsääntöisesti sarjoittain"
    And I check "Lisää oletussarjat automaattisesti"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    When I follow "Seurat" within ".sub_menu"
    Then the "Seurat" sub menu item should be selected
    And I should see "Seurat" within "h2#clubs_title"
    And I should see "seuroja" in an info message
    And I should see "Lisää seura"
    When I fill in "Testi" for "Nimi"
    And I press "Lisää seura"
    And I follow "Seurat" within ".sub_menu"
    Then I should see "Nykyiset seurat"
    When I follow "Yhteenveto"
    And I follow the first "Lisää ensimmäinen kilpailija" link
    Then I should see "Seura" within "form"
    Given the series "M" contains a competitor with attributes:
      | first_name | Matti |
      | last_name | Meikäläinen |
      | club | Testiklubi |
    When I follow the first "Kilpailijat" link
    And I select "00" from "series_start_time_4i"
    And I select "00" from "series_start_time_5i"
    And I select "00" from "series_start_time_6i"
    And I press "Luo lähtölista sarjalle"
    And I follow "Kilpailut"
    And I choose "Test race" from main menu
    And I follow "Lähtölista"
    Then I should see "Seura" within "th#table_club_title"
    When I choose "Tulokset" from sub menu
    Then I should see "Seura" within "th#table_club_title"

  Scenario: Show "Piiri" as club title when that level is selected
    Given I am an official
    And I have logged in
    And I am on the new official race page
    Then I should see "Kilpailijoiden edustustaso"
    When I fill in the following:
      | Kilpailun nimi | Test race |
      | Paikkakunta | Test town |
    And I select "Test district" from "race_district_id"
    And I choose "Pääsääntöisesti sarjoittain"
    And I check "Lisää oletussarjat automaattisesti"
    And I choose "Piiri"
    And I press "Lisää kilpailu"
    Then I should be on the official race page of "Test race"
    When I follow "Piirit" within ".sub_menu"
    Then the "Piirit" sub menu item should be selected
    And I should see "Piirit" within "h2#clubs_title"
    And I should see "piirejä" in an info message
    And I should see "Lisää piiri"
    When I fill in "Testi" for "Nimi"
    And I press "Lisää piiri"
    And I follow "Piirit" within ".sub_menu"
    Then I should see "Nykyiset piirit"
    When I follow "Yhteenveto"
    And I follow the first "Lisää ensimmäinen kilpailija" link
    Then I should see "Piiri" within "form"
    Given the series "M" contains a competitor with attributes:
      | first_name | Matti |
      | last_name | Meikäläinen |
      | club | Testiklubi |
    When I follow the first "Kilpailijat" link
    And I select "00" from "series_start_time_4i"
    And I select "00" from "series_start_time_5i"
    And I select "00" from "series_start_time_6i"
    And I press "Luo lähtölista sarjalle"
    And I follow "Kilpailut"
    And I choose "Test race" from main menu
    And I follow "Lähtölista"
    Then I should see "Piiri" within "th#table_club_title"
    When I choose "Tulokset" from sub menu
    Then I should see "Piiri" within "th#table_club_title"
