Feature: The new event form
    As a contributor
    I want to be able to submit new author events
    To be able to update the list of events

    Scenario: Post a valid event
        Given there are no events in the database
        When I visit the new event page
        And I post the form with the data
            | field              | value            |
            | author             | Paul Mason       |
            | type               | event            |
            | location           | Manchester       |
            | description        | Postcapitalism   |
            | source             | MLF              |
            | scheduled_datetime | 2015-10-22 19:30 |
        Then I should see a success message
        And there should be 1 event in the database

