# A simple wrapper class around MySQL
class parrot_mysql {

  include parrot_mysql::config

  apt::key { "percona":
      key        => "1C4CBDCDCD2EFD2A",
      key_server => "subkeys.pgp.net",
    }

  apt::source { 'percona':
    location   => 'http://repo.percona.com/apt',
    repos      => 'main',
    release    => 'precise',
    require => Apt::Key['percona'],
  }

  preseed_package { "percona-server-server-5.5":
    ensure => latest,
    module_name => 'parrot_mysql',
    before => File['/etc/mysql/conf.d/parrot.cnf'],
    require => Apt::Source['percona'],
  }

  file {'/etc/mysql/conf.d/parrot.cnf':
    ensure => file,
    content => template('parrot_mysql/parrot.cnf.erb'),
    notify => Service['mysql'],
  }

  service { mysql:
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    #subscribe => File['/etc/mysql/conf.d/parrot.cnf'],
  }

  package {'percona-server-client-5.5':
    require => [Apt::Source['percona'], Preseed_package["percona-server-server-5.5"]],

  }

  # Create the user for the DB from the host machine
  exec { "create-db-schema-and-user":
    unless => "/usr/bin/mysql -uroot -proot parrot",
    command => "/usr/bin/mysql -uroot -proot -e \"CREATE DATABASE parrot; create user root@'%' identified by 'root'; grant all on *.* to root@'%' WITH GRANT OPTION; flush privileges;\"",
    require => [Service["mysql"], Package['percona-server-client-5.5']],
  }

  # Find the DBs.
  $db_names_string = generate('/usr/bin/find', '/vagrant_databases/' ,'-name', '*.sql', '-type', 'f', '-printf', '%f\0', '-maxdepth', '1', '-mindepth', '1')
  $db_names = split($db_names_string, '\0')

  # Set up the DBs
  # Puppet magically turns our array into lots of resources.
  parrot_mysql::database_import { $db_names: }



}
