Feature: resu provides feedback on bad arguments
    Background:
        Given a docker with resu and tini

    Scenario: provides help when requested
        When the user runs "resu --help"
        Then a usage message is printed
        And the command exits without error

    Scenario: no arguments results in an error
        When the user runs "resu"
        Then a usage message is printed on stderr
        Then the command exits with an error code

    Scenario: 1 argument results in an error
        When the user runs "resu nobody:nogroup"
        Then a usage message is printed on stderr
        Then the command exits with an error code

    Scenario: 2 argument results in an error
        When the user runs "resu nobody:nogroup --"
        Then a usage message is printed on stderr
        Then the command exits with an error code

    Scenario: missing colon in user:group argument results in an error
        When the user runs "resu nocolon -- true"
        Then a usage message is printed on stderr
        Then the command exits with an error code

    Scenario: requires a -- to separate args from command
        When the user runs "resu noboody:nogroup whatever true"
        Then a usage message is printed on stderr
        And the command exits with an error code
