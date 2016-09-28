# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "puppet-master" do | machine |
    machine.vm.box = "sbeliakou/centos-6.7-x86_64"
    machine.vm.hostname = "puppet-master"
    machine.vm.network :private_network, ip: "192.168.33.10"
    machine.vm.provider "virtualbox" do |vb|
      vb.name = machine.vm.hostname
      vb.memory = 4096
      vb.cpus = 2
    end
    machine.vm.provision "shell", inline: <<-SHELL
      ln -fs /usr/share/zoneinfo/Europe/Minsk /etc/localtime
      rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
      yum install -y puppetserver vim
      echo "192.168.33.10    puppet-master puppet-master.minsk.epam.com" >> /etc/hosts
      echo "192.168.33.15    puppet-node puppet-node.minsk.epam.com" >> /etc/hosts
    SHELL
  end

  config.vm.define "node" do | machine |
    machine.vm.box = "sbeliakou/centos-6.7-x86_64"
    machine.vm.hostname = "node"
    machine.vm.network :private_network, ip: "192.168.33.15"
    machine.vm.provider "virtualbox" do | vb |
      vb.name = machine.vm.hostname
      vb.memory = 1024
      vb.cpus = 1
    end
    machine.vm.provision "shell", inline: <<-SHELL
      ln -fs /usr/share/zoneinfo/Europe/Minsk /etc/localtime
      yum install -y http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm
      yum install -y zabbix-agent vim
      echo "192.168.33.10    puppet-master puppet-master.minsk.epam.com zabbix" >> /etc/hosts
      SHELL
  end
end