class http_stack::apache(
  $apache_http_port  = 8080,
  $apache_https_port = 443
) {
  package { 'apache2':
    ensure => 'latest',
    require => Class["parrot_repos"],
  }
  package { 'libapache2-mod-php5':
    require => Class['parrot_php'],
  }

  file { '/etc/apache2/ports.conf':
    content => template('http_stack/apache/ports.conf.erb'),
    ensure => "present",
    owner => 'root',
    group => 'root',
    notify => Service['apache2'],
    require => Package['apache2'],
  }

  case $parrot_php_version {
    '5.5': {
      file { '/etc/apache2/conf-enabled/xhprof.conf':
        content => template('http_stack/apache/xhprof.conf.erb'),
        ensure => "present",
        owner => 'root',
        group => 'root',
        notify => Service['apache2'],
        require => Package['apache2'],
      }
    }
    default: {
      file { '/etc/apache2/conf.d/xhprof':
        content => template('http_stack/apache/xhprof.conf.erb'),
        ensure => "present",
        owner => 'root',
        group => 'root',
        notify => Service['apache2'],
        require => Package['apache2'],
      }
    }
  }

   # Ensure that mod-rewrite is running.
  exec { 'a2enmod-rewrite':
    command => '/usr/sbin/a2enmod rewrite',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/rewrite.load',
    user => 'root',
    group => 'root',
  }

  # Ensure that mod-ssl is running.
  exec { 'a2enmod-ssl':
    command => '/usr/sbin/a2enmod ssl',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/ssl.load',
    user => 'root',
    group => 'root',
  }

  class { 'phpmyadmin': }

  # Restart Apache after the config file is deployed.
  service { 'apache2':
    require => Package['libapache2-mod-php5'],
  }

  # Make sure the SSL directory exists.
  file { "/etc/apache2/ssl.d":
    owner => 'root',
    group => 'root',
    require => Package['apache2'],
    ensure => "directory",
  }

  # Find the cores.
  $site_names_string = generate('/usr/bin/find', '-L', '/vagrant_sites/' , '-type', 'd', '-printf', '%f\0', '-maxdepth', '1', '-mindepth', '1')
  $site_names = split($site_names_string, '\0')

  # Set up the cores
  define apacheSiteResource {
    # The file in sites-available.
    file {"/etc/apache2/sites-available/$name":
      ensure => 'file',
      content => template('http_stack/apache/vhost.erb'),
      notify => Service['apache2'],
      require => Package['apache2'],
      owner => 'root',
      group => 'root',
    }
    # The symlink in sites-enabled.
    file {"/etc/apache2/sites-enabled/20-$name.conf":
      ensure => 'link',
      target => "/etc/apache2/sites-available/$name",
      notify => Service['apache2'],
      require => Package['apache2'],
      owner => 'root',
      group => 'root',
    }

    # Add this virtual host to the hosts file
    host { $name:
      ip => '127.0.0.1',
      comment => 'Added automatically by Parrot',
      ensure => 'present',
    }

    # Add an SSL cert just for this host.
    exec { "ssl-cert-$name":
      command => "/usr/bin/openssl req -new -x509 -days 3650 -sha1 -newkey rsa:1024 -nodes -keyout $name.key -out $name.crt -subj '/O=Company/OU=Department/CN=$name'",
      require => File['/etc/apache2/ssl.d'],
      cwd => '/etc/apache2/ssl.d',
      creates => "/etc/apache2/ssl.d/$name.key",
      user => 'root',
      group => 'root',
    }

  }
  # Puppet magically turns our array into lots of resources.
  apacheSiteResource { $site_names: }





}
