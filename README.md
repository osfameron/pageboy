# pageboy

[![Build Status](https://travis-ci.org/osfameron/pageboy.svg?branch=master)](https://travis-ci.org/osfameron/pageboy)

Hub for curating and subscribing to event feeds

## Installation

Easiest way is to run a VM using Vagrant <https://www.vagrantup.com/>

    vagrant up

If you don't like Vagrant, have a look at the instructions in the
supplied Vagrantfile, which includes an inline shell script with
all details.

## Run tests

    bin/manage test
    bin/manage test --feat               # just feature tests
    bin/manage test t/controller/root.t  # single test
    bin/manage test --no_db t/view       # just view tests

## Run server

    bin/manage runserver

By default, the app runs on port :5000 on the VM, tunnelled to :5568 on
your host machine. e.g.

    http://localhost:5568/

## Redeploy database

If you need to recreate the database for any reason:

    dropdb pageboy
    createdb pageboy
    bin/manage deploydb --setup_demo

## Project structure

### Basic code

    lib/
        Pageboy.pm - OX application, defines all resources used,
                     and the route mappings.

            RouteBuilder.pm - maps requests to appropriate
                              method in Controller, and passes
                              returned structure to View for
                              rendering

            Controller.pm - defines 'get', 'post' etc. method,
                *.pm        handles parameters, calcualted results (using
                            appropriate Models) and returns a data structure.

            Model.pm        - business objects, called by controller
                Fixtures.pm - helper functions for tests/demo

            Schema.pm
                Result/*.pm - database table definitions with DBIC

            View.pm         - handles rendering logic
                Base.pm     - base class for plugins, provides methods to
                              ->bind data onto Mojo::DOM from templates
                Plugin/*.pm - process template for appropriate controller
                              (usually of the same name)
                Role/*.pm   - extracted common bindings (e.g. events list)

            Form/*.pm     - HTML::FormHandler definitions

            Geo.pm        - methods for Geolocation

            Management.pm - command line app 'bin/manage' using MooX::Cmd
                Cmd/*.pm  - all the sub commands like test etc.

    bin/
        manage - general management command.  Each subcommand is defined
                 in lib/Pageboy/Management/Cmd/*.pm above.

### Assets

    web/
        css/pageboy.scss - compiled into .css on bin/manage runserver
        images/*

    templates/ - loaded and processed by Pageboy::View.pm and its plugins
        *.html          - whole templates, with kebab-cased names
        *-fragment.html - fragments called by <include template="..." />

### Tests

    t/ - tests, run with `bin/manage test`
        controller/*.t - should use PT::Controller below and not test view
        view/*.t       - should not need database or controller
        run_cucumber_tests.t - runs feature tests
        lib/
            Pageboy/Test.pm    - subclass of app which sets up mocks for time,
                                 geolocation etc., spins up a test database,
                                 and saves controller output for testing.
                /Controller.pm - as above, also suppress output
                /Geo.pm        - mock the IP address to geolocate
                /MockView.pm

    features/     - Test::BDD::Cucumber tests, run with 
                    `bin/manage test --features`
        *.feature                   - features in human-readable Cucumber
                                      format
        step_definitions/*_steps.pl - accompanying Perl code, all loaded, in 
                                      alphabetical order.

### Provisioning

    Vagrantfile - config to automate virtual machine creation on first `vagrant up`

    .travis.yml - config for Travis testing

    provision/
        cpanfile            - all the CPAN modules to load
        minimal-dotfiles/.* - very basic configuration files to start

See https://travis-ci.org/osfameron/pageboy for automated CI builds.

## Random notes

 - http://blog.jonudell.net/elmcity-project-faq/ via @amcewen
 - https://opentechcalendar.co.uk/ (also mentioned by @amcewen, I've met the dev at mysoc Edinburgh event)
