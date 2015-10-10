# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV['BOX_NAME']  || "trusty64"
BOX_URI = ENV['BOX_URI']    || "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
HOST_PORT = ENV['HOST_PORT'] || 5568

Vagrant.configure("2") do |config|
  # Setup virtual machine box. This VM configuration code is always executed.
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI
  config.vm.network "forwarded_port", guest: 5000, host: HOST_PORT

  config.vm.provider "virtualbox" do |v|
   v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
   v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.ssh.forward_x11 = true

  config.vm.provision :shell, privileged: false, inline: <<-EOS
    if ! test -f done.update; then
      sudo apt-get update
      sudo apt-get install -q -y git vim ack-grep
      sudo apt-get install -q -y perlbrew libssl-dev postgresql libpq-dev

      # https URL because no key yet
      git clone https://github.com/osfameron/pageboy.git
      pushd pageboy

      perlbrew init

      cp provision/minimal-dotfiles/.??* ~
      source ~/.bash_aliases

      perlbrew install perl-5.22.0
      perlbrew switch perl-5.22.0
      perlbrew install-cpanm

      cpanm --force Data::Dump::Streamer # https://rt.cpan.org/Public/Bug/Display.html?id=102369

      cpanm --installdeps ./provision/

      mkdir data; pushd data
      wget --quiet http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
      gunzip GeoLite2-City.mmdb.gz
      popd

      bin/manage test

      sudo -u postgres createuser -d vagrant
      createdb pageboy
      bin/manage deploydb --setup_demo

      popd
      touch done.update
    fi
  EOS

end
