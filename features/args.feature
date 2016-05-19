Feature: resu provides feedback on bad arguments
  Background:
    Given a docker with resu and tini

  Scenario: no arguments results in an error
    When the user runs "resu"
    Then the command exits with an error code

  Scenario: provides help when requested
    When the user runs "resu --help"
    Then a usage message is printed
    And the command exits without error
