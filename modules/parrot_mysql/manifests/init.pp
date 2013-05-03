# A simple wrapper class around MySQL
class parrot_mysql {

  include parrot_mysql::config

  preseed_package { "mysql-server":
    ensure => latest,
    module_name => 'parrot_mysql',
    before => File['/etc/mysql/conf.d/parrot.cnf'],
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

  package {'mysql-client': }

  # Create the user for the DB from the host machine
  exec { "create-db-schema-and-user":
    unless => "/usr/bin/mysql -uroot -proot parrot",
    command => "/usr/bin/mysql -uroot -proot -e \"CREATE DATABASE parrot; create user root@'%' identified by 'root'; grant all on *.* to root@'%' WITH GRANT OPTION; flush privileges;\"",
    require => [Service["mysql"], Package['mysql-client']],
  }

}
