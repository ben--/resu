Feature: resu changes the user when running commands
    Background:
        Given a docker with resu and tini

    Scenario: the default id is root
        When the user runs "id -un"
        Then the command prints the output "root"

    Scenario: resu changes the user id
        When the user runs "resu nobody -- id -un"
        Then the command prints the output "nobody"
