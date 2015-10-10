# pageboy
Hub for curating and subscribing to event feeds

## Installation

Easiest way is to run a VM using Vagrant <https://www.vagrantup.com/>

    vagrant up

If you don't like Vagrant, have a look at the instructions in the
supplied Vagrantfile, which includes an inline shell script with
all details.

## Run tests

    bin/manage test

## Run server

    bin/manage runserver

By default, the app runs on port :5000 on the VM, tunnelled to :5569 on
your host machine. e.g.

    http://localhost:5569/

## Redeploy database

If you need to recreate the database for any reason:

    dropdb pageboy
    createdb pageboy
    bin/manage deploydb --setup_demo

## Random notes

 - http://blog.jonudell.net/elmcity-project-faq/ via @amcewen
 - https://opentechcalendar.co.uk/ (also mentioned by @amcewen, I've met the dev at mysoc Edinburgh event)
