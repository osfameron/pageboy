Feature: The index page
    As a reader
    I want to look at the Pageboy landing page
    To see upcoming author events in my area

    Background:
        Given an app with some fixtures

    Scenario: basic
        Given no geolocation
        When I visit the landing page
        Then I should see some events
