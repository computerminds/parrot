# -*- mode: ruby -*-
# vi: set ft=ruby :
def parse_config(
  config_file=File.expand_path(File.join(File.dirname(__FILE__), 'config.yaml'))
)
  require 'yaml'
  config = {
    'sites' => "sites",
    'databases' => "databases",
    'memory' => '2048',
  }
  if File.exists?(config_file)
    overrides = YAML.load_file(config_file)
    config.merge!(overrides)
  end
  config
end

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  custom_config = parse_config

  # Note the backticks on this next line.
  architecture = `uname -m`.strip
  if ((architecture == 'x86_64') || (architecture == 'ia64'))
    bits = 64
  else
    bits = 32
  end


  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  if (bits == 32)
    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  else
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  # Give the created VM 768M of RAM
  config.vm.provider :virtualbox do |box|
   box.customize ['modifyvm', :id, '--memory', custom_config['memory']]
   box.name = "Parrot"
   # Boot with a GUI so you can see the screen. (Default is headless)
   # box.gui = true
  end

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: "192.168.50.4"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.


  # Solr
  config.vm.network :forwarded_port, :guest => 8983, :host => 8983
  # MySQL
  config.vm.network :forwarded_port, :guest => 3306, :host => 3306
  # Varnish
  config.vm.network :forwarded_port, :guest => 80, :host => 8181
  # Apache
  config.vm.network :forwarded_port, :guest => 8080, :host => 8080
  # HTTPS
  config.vm.network :forwarded_port, :guest => 443, :host => 1443
  # Dovecot - IMAP
  config.vm.network :forwarded_port, :guest => 143, :host => 1143

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.synced_folder "parrot-config", "/vagrant_parrot_config"

  config.vm.synced_folder custom_config['sites'], "/vagrant_sites", :nfs => true
  config.vm.synced_folder custom_config['databases'], "/vagrant_databases"
  

  # Use Vagrant Cachier
  config.cache.auto_detect = true

  # Enable ssh key forwarding
  config.ssh.forward_agent = true

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file precise64.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #

  # A quick bootstrap to get Puppet installed.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "bootstrap.pp"
    puppet.module_path = "modules"
    #puppet.options = "--verbose --debug"
  end

  # And now the meat.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "parrot.pp"
    puppet.module_path = "modules"
    #puppet.options = "--verbose --debug"
  end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # IF you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
