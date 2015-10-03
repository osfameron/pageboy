Feature: The index page
    As a reader
    I want to look at the Pageboy landing page
    To see upcoming author events in my area

    Background:
        Given some upcoming events in
            | location      |
            | Liverpool  |
            | Liverpool  |
            | Liverpool  |
            | Manchester |
            | Manchester |

    Scenario: Liverpool
        Given I am in Liverpool (based on my IP address)
        When I visit the landing page
        Then I should see 3 events

    Scenario: Manchester
        Given I am in Manchester (based on my IP address)
        When I visit the landing page
        Then I should see 2 events

    Scenario: Amsterdam
        Given I am in Amsterdam (based on my IP address)
        When I visit the landing page
        Then I should see 0 events

    Scenario: Local IP (e.g. local development or oddities)
        Given I have an invalid or local IP address
        When I visit the landing page
        Then I should see 5 events

