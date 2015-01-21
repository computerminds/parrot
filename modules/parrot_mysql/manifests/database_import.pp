define parrot_mysql::database_import {

  $raw_db_name = regsubst($name, '\.sql(\.gz)?$', '')

  $db_name = regsubst($raw_db_name, '[\.-]', '_', 'G')

  # Create the user for the DB from the host machine
  exec { "create-db-$name":
    unless => "/usr/bin/mysql -uroot -proot $db_name",
    command => "/usr/bin/mysql -uroot -proot -e \"CREATE DATABASE $db_name;\"",
    require => [Service["mysql"], Package['mysql-client']],
  }

  # Import the database dump from an optionally compressed file.
  if $name =~ /\.sql$/ {
    exec { "import-db-$name":
      refreshonly => true,
      subscribe => Exec["create-db-$name"],
      command => "/usr/bin/mysql -uroot -proot $db_name < /vagrant_databases/$name",
    }
  }
  elsif $name =~ /\.sql.gz$/ {
    exec { "import-db-$name":
      refreshonly => true,
      subscribe => Exec["create-db-$name"],
      command => "/bin/zcat /vagrant_databases/$name | /usr/bin/mysql -uroot -proot $db_name",
    }
  }
  else{
     notice("Could not match $name")
  }
}