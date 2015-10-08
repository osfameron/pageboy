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

  config.vm.provision :shell, inline: <<-EOS
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
  EOS

end
