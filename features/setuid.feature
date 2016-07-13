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

        # Error on unknown name lookup
