# -*- mode: ruby -*-
# vi: set ft=ruby :
def parse_config(
  config_file=File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
)
  require 'yaml'
  config = {
    'sites' => "sites",
    'webroot_subdir' => "",
    'databases' => "databases",
    'memory' => '2048',
    'cpus' => '1',
    'with_gui' => false,
    'ip' => "192.168.50.4",
    'php_version' => '5.3',
    'mysql_version' => '5.5',
    'box_name' => 'Parrot-Trusty',
    'varnish_enabled' => false,
    'local_user_uid' => Process.uid,
    'local_user_gid' => Process.gid,
    'forward_solr' => true,
    'forward_mysql' => true,
    'forward_varnish' => true,
    'forward_apache' => true,
    'forward_https' => true,
    'forward_dovecot' => true,
    'solr_port' => 8983,
    'mysql_port' => 3306,
    'varnish_port' => 8181,
    'apache_port' => 8080,
    'https_port' => 1443,
    'dovecot_port' => 1143,
  }
  if File.exists?(config_file)
    overrides = YAML.load_file(config_file)
    config.merge!(overrides)
  end
  config
end

Vagrant.require_version ">= 1.3.0"

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

  ################# VMWare Fusion ########################
  config.vm.provider "vmware_fusion" do |box, override|
    if (bits == 32)
      override.vm.box_url = "https://atlas.hashicorp.com/puphpet/boxes/ubuntu1404-x32"
      override.vm.box = "puphpet/ubuntu1404-x32"
      override.vm.box_version = "20151128"
    else
      override.vm.box_url = "https://atlas.hashicorp.com/puphpet/boxes/ubuntu1404-x64"
      override.vm.box = "puphpet/ubuntu1404-x64"
      override.vm.box_version = "20151128"
    end

    box.vmx["memsize"] = custom_config['memory']
    box.vmx["numvcpus"] = custom_config['cpus']
    # Boot with a GUI so you can see the screen. (Default is headless)
    box.gui = custom_config['with_gui']
  end

  #################   Parallels   ########################
  config.vm.provider "parallels" do |box, override|
    override.vm.box_url = "https://atlas.hashicorp.com/puphpet/boxes/ubuntu1404-x64"

    box.memory = custom_config['memory']
    box.cpus = custom_config['cpus']

    box.name = custom_config['box_name']
  end

  ################# Virtual Box ########################
  config.vm.provider :virtualbox do |box, override|
    if (bits == 32)
      override.vm.box = "ubuntu/trusty32"
    else
      override.vm.box = "ubuntu/trusty64"
    end

    # Specify number of cpus/cores to use
    box.customize ["modifyvm", :id, "--cpus", custom_config['cpus']]

    box.customize ['modifyvm', :id, '--memory', custom_config['memory']]
    box.name = custom_config['box_name']
    # Boot with a GUI so you can see the screen. (Default is headless)
    box.gui = custom_config['with_gui']
  end

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: custom_config['ip']

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.


  # Solr
  if custom_config['forward_solr']
    config.vm.network :forwarded_port, :guest => 8983, :host => custom_config['solr_port']
  end
  # MySQL
  if custom_config['forward_mysql']
    config.vm.network :forwarded_port, :guest => 3306, :host => custom_config['mysql_port']
  end
  # Varnish
  if custom_config['forward_varnish']
    config.vm.network :forwarded_port, :guest => 80, :host => custom_config['varnish_port']
  end
  # Apache
  if custom_config['forward_apache']
    config.vm.network :forwarded_port, :guest => 8080, :host => custom_config['apache_port']
  end
  # HTTPS
  if custom_config['forward_https']
    config.vm.network :forwarded_port, :guest => 443, :host => custom_config['https_port']
  end
  # Dovecot - IMAP
  if custom_config['forward_dovecot']
    config.vm.network :forwarded_port, :guest => 143, :host => custom_config['dovecot_port']
  end

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.synced_folder "parrot-config", "/vagrant_parrot_config"

  config.vm.synced_folder custom_config['sites'], "/vagrant_sites", :nfs => true
  config.vm.synced_folder custom_config['databases'], "/vagrant_databases"


  # Use Vagrant Cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Enable ssh key forwarding
  config.ssh.forward_agent = true

  # A quick bootstrap to get Puppet installed.
  config.vm.provision "shell", path: "scripts/bootstrap.sh"

  # And now the meat.
  config.vm.provision :puppet do |puppet|
    #puppet.options = "--verbose --debug"
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "parrot.pp"
    puppet.module_path = ["forge-modules", "modules"]
    # Add a custom fact so we can reliably hit the host IP from the guest.
    puppet.facter = {
      "vagrant_guest_ip" => custom_config['ip'],
      "parrot_php_version" => custom_config['php_version'],
      "parrot_mysql_version" => custom_config['mysql_version'],
      "apache_vhost_webroot_subdir" => custom_config['webroot_subdir'],
      "parrot_varnish_enabled" => custom_config['varnish_enabled'],
      "vagrant_host_user_uid" => custom_config['local_user_uid'],
      "vagrant_host_user_gid" => custom_config['local_user_gid'],
    }
  end
end
