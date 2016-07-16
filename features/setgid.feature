Feature: resu changes the group when running commands
    Background:
        Given a docker with resu and tini

    Scenario: the default id is root
        When the user runs "id -gn"
        Then the command prints the output "root"

    Scenario: resu changes the effective group id
        When the user runs "resu nobody:nogroup -- id -gn"
        Then the command prints the output "nogroup"

    Scenario: resu changes the real group id
        When the user runs "resu nobody:nogroup -- id -rgn"
        Then the command prints the output "nogroup"

    Scenario: resu tolerates an explicit root group
        When the user runs "resu nobody:root -- id -gn"
        Then the command prints the output "root"

    Scenario: resu accepts a numeric group id
        When the user runs "resu nobody:42 -- id -g"
        Then the command prints the output "42"

    Scenario: resu fails cleanly with an unknown group name
        When the user runs "resu nobody:unknown -- id -gn"
        Then a "resu: Unknown group `unknown'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with garbage on the name of a numeric UID
        When the user runs "resu nobody:42garbage -- id -gn"
        Then a "resu: Unknown group `42garbage'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with empty group
        When the user runs "resu 'nobody:' -- id -gn"
        Then a "resu: Unknown group `'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with space-only group
        When the user runs "resu 'nobody: ' -- id -gn"
        Then a "resu: Unknown group ` '" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly when setgid fails
        When the user runs "resu nobody:nogroup -- resu nobody:root -- id"
        Then the command prints no output
        And a "resu: Operation not permitted" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly when setgid fails
        When the user runs "resu nobody:nogroup -- resu nobody:0 -- id"
        Then the command prints no output
        And a "resu: Operation not permitted" error message is printed
        And the command exits with an error code
