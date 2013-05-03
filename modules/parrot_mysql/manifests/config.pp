class parrot_mysql::config {


  $innodb_buffer_pool_size_float = $::memorysize_raw / 16 / 1024
  $innodb_buffer_pool_size = sprintf('%iM', $innodb_buffer_pool_size_float)

  $key_buffer_size_float = $::memorysize_raw / 64 / 1024
  $key_buffer_size = sprintf('%iM', $key_buffer_size_float)

  $mysql_max_connections_float = $::memorysize_raw / 1024 / 50
  $mysql_max_connections = sprintf('%i', $mysql_max_connections_float)

  $table_cache = 1000

  $mysql_query_cache_limit = '1M'

  $mysql_query_cache_size = '16M'

}
