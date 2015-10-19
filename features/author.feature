Feature: The author page
    As a reader
    I want to be able to view an author page
    To see details and events about that author

    Background:
        Given an author
            | field              | value                                  |
            | author             | Paul Mason                             |
            | description        | Award-winning economist and journalist |
            | twitter            | paulmasonnews                          |
            
    Scenario: An author page
        Given some events
            | author          | description         |
            | Paul Mason      | Postcapitalism      |
            | Paul Mason      | Postcapitalism      |
            | Owen Jones      | The Establishment   |
            | Margaret Atwood | The Heart Goes Last |
            | Margaret Atwood | The Heart Goes Last |
            | Margaret Atwood | The Heart Goes Last |
        When I visit the author page for Paul Mason
        Then I should see 2 events

