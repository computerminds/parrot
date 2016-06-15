class http_stack::apache(
  $apache_http_port  = 8080,
  $apache_https_port = 443
) {

  $apache_packages = [
    'apache2',
    'apache2-utils',
  ]
  package { $apache_packages:
    ensure => 'latest',
    require => Class["parrot_repos"],
  }

  package {'apache2-mpm-worker':
    ensure => 'absent',
  }

  file { '/etc/apache2/ports.conf':
    content => template('http_stack/apache/ports.conf.erb'),
    ensure => "present",
    owner => 'root',
    group => 'root',
    notify => Service['apache2'],
    require => Package['apache2'],
  }

    package { "apache2-threaded-dev":
      ensure => absent,
    }
    file { '/etc/apache2/conf-enabled/xhprof.conf':
      content => template('http_stack/apache/xhprof.conf.erb'),
      ensure => "present",
      owner => 'root',
      group => 'root',
      notify => Service['apache2'],
      require => Package['apache2'],
    }
    file { '/etc/apache2/conf-enabled/php-fpm.conf':
      content => template('http_stack/apache/2.4-php-fpm.conf.erb'),
      ensure => "present",
      owner => 'root',
      group => 'root',
      notify => Service['apache2'],
      require => Package['apache2'],
    }

  # Ensure that mod-rewrite is running.
  exec { 'a2enmod-rewrite':
    command => '/usr/sbin/a2enmod rewrite',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/rewrite.load',
    user => 'root',
    group => 'root',
  }

  # Ensure that mod-deflate is running.
  exec { 'a2enmod-deflate':
    command => '/usr/sbin/a2enmod deflate',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/deflate.load',
    user => 'root',
    group => 'root',
  }

  # Ensure that mod-expires is running.
  exec { 'a2enmod-expires':
    command => '/usr/sbin/a2enmod expires',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/expires.load',
    user => 'root',
    group => 'root',
  }

  # Ensure that mod-proxy-fcgi is running.
  exec { 'a2enmod-fcgi':
    command => '/usr/sbin/a2enmod proxy_fcgi',
    require => Package['apache2'],
    creates => '/etc/apache2/mods-enabled/proxy_fcgi.load',
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

  # Ensure that mod-actions is running.
    exec { 'a2enmod-actions':
      command => '/usr/sbin/a2enmod actions',
      require => Package['apache2'],
      creates => '/etc/apache2/mods-enabled/actions.load',
      user => 'root',
      group => 'root',
    }

  # Ensure that mod-php5 cgi is not running.
  exec { 'a2dismod-php5_cgi':
    command => '/usr/sbin/a2dismod php5_cgi',
    require => Package['apache2'],
    onlyif => '/usr/bin/test -f /etc/apache2/mods-enabled/php5_cgi.load',
    user => 'root',
    group => 'root',
  }

#  class { 'phpmyadmin': }

  # Restart Apache after the config file is deployed.
  service { 'apache2':
    ensure => 'running',
  }


  # Make sure the SSL directory exists.
  file { "/etc/apache2/ssl.d":
    owner => 'root',
    group => 'root',
    require => Package['apache2'],
    ensure => "directory",
  }

  # Find the sites.
  $site_names_string = generate('/usr/bin/find', '-L', '/vagrant_sites/' , '-type', 'd', '-printf', '%f\0', '-maxdepth', '1', '-mindepth', '1')
  $site_names = split($site_names_string, '\0')
  # Puppet magically turns our array into lots of resources.
  http_stack::apache::site { $site_names: }

}
