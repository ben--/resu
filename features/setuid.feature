Feature: resu changes the user when running commands
    Background:
        Given a docker with resu and tini

    Scenario: the default id is root
        When the user runs "id -un"
        Then the command prints the output "root"

    Scenario: resu changes the effective user id
        When the user runs "resu nobody:nogroup -- id -un"
        Then the command prints the output "nobody"

    Scenario: resu changes the real user id
        When the user runs "resu nobody:nogroup -- id -run"
        Then the command prints the output "nobody"

    Scenario: resu tolerates an explicit root user
        When the user runs "resu root:nogroup -- id -un"
        Then the command prints the output "root"

    Scenario: resu accepts a numeric user id
        When the user runs "resu 42:nogroup -- id -u"
        Then the command prints the output "42"

    Scenario: resu fails cleanly with an unknown username
        When the user runs "resu unknown:nogroup -- id -un"
        Then a "resu: Unknown user `unknown'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with garbage on the name of a numeric UID
        When the user runs "resu 42garbage:nogroup -- id -un"
        Then a "resu: Unknown user `42garbage'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with empty user
        When the user runs "resu ':nogroup' -- id -un"
        Then a "resu: Unknown user `'" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly with space-only user
        When the user runs "resu ' :nogroup' -- id -un"
        Then a "resu: Unknown user ` '" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly when setuid fails
        When the user runs "resu nobody:nogroup -- resu root:nogroup -- id"
        Then the command prints no output
        And a "resu: Operation not permitted" error message is printed
        And the command exits with an error code

    Scenario: resu fails cleanly when setuid fails
        When the user runs "resu nobody:nogroup -- resu 0:nogroup -- id"
        Then the command prints no output
        And a "resu: Operation not permitted" error message is printed
        And the command exits with an error code
