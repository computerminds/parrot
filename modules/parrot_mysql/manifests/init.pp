# A simple wrapper class around MySQL
class parrot_mysql {

    include parrot_mysql::config


	$running = 'running'
	
	class { 'mysql::server':
		status => $running,
	}
	package {'mysql-client': }

	exec { "create-db-schema-and-user":
	  unless => "/usr/bin/mysql -uroot -proot parrot",
      command => "/usr/bin/mysql -uroot -proot -e \"CREATE DATABASE parrot; create user root@'%' identified by 'root'; grant all on *.* to root@'%' WITH GRANT OPTION; flush privileges;\"",
      require => [Class["mysql::server"], Package['mysql-client']],
    }
  
  file {'/etc/mysql/conf.d/parrot.cnf':
    content => template('parrot_mysql/parrot.cnf.erb'),
# Need to fix this because, at the moment changes to this file don't trigger a MySQL restart.
#    notify => Service['mysql'],
    require => [Class['parrot_mysql::config'], Service['mysql'], ],
  }
	
}