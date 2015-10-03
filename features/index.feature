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
        Given I am in Liverpool
        When I visit the landing page
        Then I should see 3 events

    Scenario: Manchester
        Given I am in Manchester
        When I visit the landing page
        Then I should see 2 events
