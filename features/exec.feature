Feature: resu changes the user when running commands
    Background:
        Given a docker with resu and tini

    Scenario: resu runs the command given to it
        When the user runs "resu nobody -- echo hello"
        Then the command prints the output "hello"

    # success return code
    # fail return code
    # command not found
