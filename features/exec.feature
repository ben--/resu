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

    # command not found
