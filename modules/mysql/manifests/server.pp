class mysql::server($status = 'running') {
  
  if ! ($status in [ "running", "stopped" ]) {
    fail("ensure parameter must be running or stopped")
  }
  
  preseed_package { "mysql-server":
    ensure => installed,
    module_name => 'mysql',
  }

  service { mysql:
    ensure => $status,
    hasstatus => true,
    require => preseed_package["mysql-server"],
  }
}
