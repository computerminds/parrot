class parrot_php {

  #Install PHP
  package { ['php5',
             'php5-suhosin',
             'php5-cgi',
             'php-apc',
             'php5-cli',
             'php5-curl',
             'php5-mysql',
             'php5-gd',
             'php5-sqlite',
             'php5-xmlrpc',
             'php5-xdebug',
  ]:
    ensure => 'latest',
#    notify => Exec["force-reload-apache"],

  }

  apt::source { 'php5-xhprof':
    location   => 'http://ppa.launchpad.net/brianmercer/php5-xhprof/ubuntu/',
    repos      => 'main',
    release    => 'precise',
    require => Apt::Key['php5-xhprof'],
  }

  apt::key { "php5-xhprof":
      key        => "8D0DC64F",
      key_server => "keyserver.ubuntu.com",
    }

  package { 'php5-xhprof':
    require => Apt::Source["php5-xhprof"],
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

  # Pull in the pear class, which will install uploadprogress for us.
  #class {'pear':
  #  require => Package['php5'],
  #}
}
