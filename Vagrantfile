MIN_REQUIRED_VAGRANT_VERSION = '2.0.0'

if Vagrant::VERSION < MIN_REQUIRED_VAGRANT_VERSION
  $stderr.puts "ERROR: We require Vagrant version >=#{MIN_REQUIRED_VAGRANT_VERSION}. Please upgrade. http://downloads.vagrantup.com/\n"
  exit 1
end


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.168.168"
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.ssh.forward_agent = true
  config.ssh.username="vagrant"
  config.ssh.password="vagrant"

  required_plugins = %w( vagrant-hostsupdater )
  required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
  end

  config.vm.provider "virtualbox" do |vb|
    vb.name = "lab-db-01.pipedrive.local"
    vb.memory = "2048"
    vb.cpus = 1
  end

# comment this as it require rw on host file
#  config.vm.define "hn" do |hn| 
#     hn.vm.hostname = "lab-db-01.pipedrive.local"
#  end

config.vm.provision "percona", type: "ansible_local" do |ansible|
      ansible.install_mode = "pip"
      ansible.compatibility_mode = "2.0"
      ansible.version = "2.3.2.0"
      ansible.inventory_path = "hosts"
      ansible.limit = "pipedrive"
      ansible.raw_arguments = []
      ansible.skip_tags = []
      ansible.playbook = "percona.yml"

  end
 config.vm.provision "db", type: "shell", privileged: false, inline: "for i in /vagrant/*.sql; do mysql -uroot  test <$i;done"
end
