Feature: resu runs in a variety of environments

    Scenario: resu runs on Alpine base images
        Given an Alpine base image with resu and tini
        When the user runs "resu nobody:nogroup -- id -un"
        Then the command prints the output "nobody"
