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

  config.vm.provision :shell, path: 'provision/provision.sh'

end
