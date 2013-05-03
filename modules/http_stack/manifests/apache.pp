class http_stack::apache {
  package { 'apache2': }
  package { 'libapache2-mod-php5': }

  file { '/etc/apache2/ports.conf':
    source => "puppet:///modules/http_stack/ports.conf",
    ensure => "present",
  }

  File['/etc/apache2/ports.conf'] ~> Service['apache2']

   # Ensure that mod-rewrite is running.
  exec { 'a2enmod':
    command => '/usr/sbin/a2enmod rewrite',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/rewrite.load',
    user => 'root',
    group => 'root',
  }

  class { 'phpmyadmin': }

  file { "/etc/apache2/conf.d/xhprof":
    source => 'puppet:///modules/http_stack/apache/xhprof',
    owner => 'root',
    group => 'root',
    require => Package['apache2'],
    notify => Service['apache2'],
  }

  # Restart Apache after the config file is deployed.
  service { 'apache2':  }

  # Find the cores.
  $site_names_string = generate('/usr/bin/find', '/vagrant_sites/' , '-type', 'd', '-printf', '%f\0', '-maxdepth', '1', '-mindepth', '1')
  $site_names = split($site_names_string, '\0')

  # Set up the cores
  define apacheSiteResource {
    # The file in sites-available.
    file {"/etc/apache2/sites-available/$name":
      ensure => 'file',
      content => template('http_stack/apache/vhost.erb'),
      notify => Service['apache2'],
    }
    # The symlink in sites-enabled.
    file {"/etc/apache2/sites-enabled/20-$name":
      ensure => 'link',
      target => "/etc/apache2/sites-available/$name",
      notify => Service['apache2'],
    }

  }
  # Puppet magically turns our array into lots of resources.
  apacheSiteResource { $site_names: }





}
