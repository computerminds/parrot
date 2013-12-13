define parrot_mysql::database_import {

  $db_name = regsubst($name, '\.sql$', '')

  # Create the user for the DB from the host machine
  exec { "create-db-$name":
    unless => "/usr/bin/mysql -uroot -proot $db_name",
    command => "/usr/bin/mysql -uroot -proot -e \"CREATE DATABASE $db_name;\"",
    require => [Service["mysql"], Package['mysql-client']],
  }

  exec { "import-db-$name":
    refreshonly => true,
    subscribe => Exec["create-db-$name"],
    command => "/usr/bin/mysql -uroot -proot $db_name < /vagrant_databases/$name",

  }
}