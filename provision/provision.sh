#!/bin/bash

if ! test -f done.update; then
    apt-get update
    apt-get install -q -y git vim ack-grep
    apt-get install -q -y perlbrew libssl-dev postgresql libpq-dev

    # https URL because no key yet
    git clone https://github.com/osfameron/pageboy.git
    cd pageboy

    cp provsion/minimal/.* ~

    perlbrew install perl-5.22.0
    perlbrew switch perl-5.22.0
    echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.bashrc
    perlbrew install-cpanm

    cpanm --force Data::Dump::Streamer # https://rt.cpan.org/Public/Bug/Display.html?id=102369

    cpanm --installdeps ./provision/

    touch done.update
done
