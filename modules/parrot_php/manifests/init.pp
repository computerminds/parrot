class parrot_php {

  $php_packages = [
   'php5',
#   'php5-suhosin',
   'php5-cgi',
   'php-apc',
   'php5-cli',
   'php5-curl',
   'php5-mysql',
   'php5-gd',
   'php5-sqlite',
   'php5-xmlrpc',
   'php5-xdebug',
   'php5-fpm',
  ]

  #Install PHP
  package { $php_packages:
    ensure => 'latest',
    require => Class["parrot_repos"],
  }

  # We don't use xhprof from the ubuntu package any more.
  package { 'php5-xhprof':
    ensure => 'purged',
  }


  package { 'graphviz': }

  # Set up APC
  #file {'/etc/php5/conf.d/apc.ini':
  #  content => template('pergola_php/apc.ini.erb'),
  #  notify => [ Package['php-apc'], Class['pergola_apache'], ],
  #  require => Class['pergola_php::config'],
  #}

  # Set up php.ini.
  file {'/etc/php5/conf.d/zy-parrot.ini':
    source => '/vagrant_parrot_config/php/parrot-base.ini',
    require => Package['php5'],
    owner => 'root',
    group => 'root',
    notify => Service['apache2'],
  }

  # Set up php.ini.
  file {'/etc/php5/conf.d/zz-parrot.ini':
    source => '/vagrant_parrot_config/php/parrot-local.ini',
    require => Package['php5'],
    owner => 'root',
    group => 'root',
    notify => Service['apache2'],
  }

  case $parrot_php_version {
    '5.5': {
      file {'/etc/php5/apache2/conf.d/50-parrot.ini':
        ensure => 'link',
        target => '/etc/php5/conf.d/zy-parrot.ini',
        notify => Service['apache2'],
        require => File['/etc/php5/conf.d/zy-parrot.ini'],
      }

      file {'/etc/php5/apache2/conf.d/80-parrot.ini':
        ensure => 'link',
        target => '/etc/php5/conf.d/zz-parrot.ini',
        notify => Service['apache2'],
        require => File['/etc/php5/conf.d/zz-parrot.ini'],
      }
    }
  }

  # Pull in the pear class, which will install uploadprogress for us.
  class {'pear':
    require => Package['php5'],
    notify => Service['apache2'],
  }


  host { 'host_machine.parrot':
    ip => regsubst($vagrant_guest_ip,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\1.\2.\3.1'),
    comment => 'Added automatically by Parrot',
    ensure => 'present',
  }
}
