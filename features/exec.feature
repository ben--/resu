Feature: resu changes the user when running commands
    Background:
        Given a docker with resu and tini

    Scenario: resu runs the command given to it
        When the user runs "resu nobody -- echo hello"
        Then the command prints the output "hello"

    Scenario: resu returns success return values
        When the user runs "resu nobody -- true"
        Then the command exits without error

    Scenario: resu returns failure return values
        When the user runs "resu nobody -- false"
        Then the command exits with an error code

    Scenario: resu prints and returns an error when the command is not found
        When the user runs "resu nobody -- unknown"
        Then a "resu: No such file or directory" error message is printed
        And the command exits with an error code

    Scenario: resu prints and returns an error when the command is not executable
        When the user runs "resu nobody -- /etc/passwd"
        Then a "resu: Permission denied" error message is printed
        And the command exits with an error code
