Feature: resu changes the user when running commands
    Background:
        Given a docker with resu and tini

    Scenario: the default id is root
        When the user runs "id -un"
        Then the command prints the output "root"

    Scenario: resu changes the effective user id
        When the user runs "resu nobody -- id -un"
        Then the command prints the output "nobody"

    Scenario: resu changes the real user id
        When the user runs "resu nobody -- id -run"
        Then the command prints the output "nobody"

    Scenario: resu tolerates an explicit root user
        When the user runs "resu root -- id -un"
        Then the command prints the output "root"

    Scenario: resu accepts a numeric user id
        When the user runs "resu 42 -- id -u"
        Then the command prints the output "42"

    Scenario: resu fails cleanly with an unknown username
        When the user runs "resu unknown -- id -un"
        Then a "resu: Unknown user `unknown'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with garbage on the name of a numeric UID
        When the user runs "resu 42garbage -- id -un"
        Then a "resu: Unknown user `42garbage'" error message is printed
        And the command exits with an error code


        # Error on number with trailing garbage
        # #rror on empty name
