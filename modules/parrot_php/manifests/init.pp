class parrot_php (
  $fpm_user_uid  = $vagrant_host_user_uid,
  $fpm_user_gid  = $vagrant_host_user_gid,
)
{

  include '::php'

  $php_packages = [
   'php5-cgi',
   'php5-sqlite',
   'php5-xmlrpc',
  ]

  class { [
    '::php::fpm',
    '::php::cli',
    '::php::extension::curl',
    '::php::extension::gd',
    '::php::extension::mysql',
    '::php::pear',
    '::php::dev',

  ]: }

  php::fpm::config { 'parrot-settings':
    config => [
      "set PHP/memory_limit 256M",
      "set PHP/max_execution_time 300",
      'set PHP/error_reporting "E_ALL | E_STRICT"',
      "set PHP/display_errors On",
      "set PHP/html_errors On",
      "set PHP/display_startup_errors On",
      "set PHP/log_errors On",
      "set PHP/error_log syslog",
      "set PHP/post_max_size 8M",
      "set PHP/realpath_cache_size 1M",
      "set PHP/realpath_cache_ttl 300",
    ],
  }

  class { '::php::extension::opcache':
    settings => [
      "set .anon/opcache.memory_consumption 256",
      "set .anon/opcache.enable 1",
    ],
  }

  class { '::php::extension::xdebug':
    settings => [
      "set XDebug/xdebug.max_nesting_level 256",
      "set XDebug/xdebug.remote_enable 1",
      "set XDebug/xdebug.remote_handler dbgp",
      "set XDebug/xdebug.remote_host host_machine.parrot",
      "set XDebug/xdebug.remote_port 9000",
    ],
  }

  php::fpm::config { 'xdebug-parrot-settings-phpstorm':
    setting => 'xdebug.file_link_format',
    value   => '"javascript:var rq = new XMLHttpRequest(); rq.open(\'GET\', \'http://localhost:8091?message=%f:%l\', true); rq.send(null);"',
    file    => "${php::params::config_root_ini}/xdebug.ini",
    section => 'XDebug',
  }

  $log_level = 'debug'
  $emergency_restart_threshold = '0'
  $emergency_restart_interval  = '0'
  $process_control_timeout     = '0'
  file { '/etc/php5/fpm/php-fpm.conf':
    notify  => Service['php5-fpm'],
    content => template('php/fpm/php-fpm.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  # Manually install the xmlrpc extension.
  php::extension { 'xmlrpc':
    ensure   => $::php::params::ensure,
    package  => 'php5-xmlrpc',
    provider => undef,
  }

  php::fpm::pool { 'www':
    listen => '127.0.0.1:9999',
    pm_max_children => 10,
    pm_start_servers => 2,
    pm_max_requests => 100,
    chdir => '/',
    pm_min_spare_servers => 1,
    pm_max_spare_servers => 4,
    user => 'host_user',
    group => $fpm_user_gid,
  }


  # We need a user to exist that will run our PHP.
  user {'host_user':
    ensure => 'present',
    uid => $fpm_user_uid,
    gid => $fpm_user_gid,
  }


  package { 'graphviz': }

  # Install extensions
  Php::Extension <| |>
    # Configure extensions
    -> Php::Config <| |>

  # Restart FPM if an extension is installed or configured.
  Php::Extension <| |> ~> Service['php5-fpm']
  Php::Config <| |>    ~> Service['php5-fpm']

#  # Set up php.ini.
#  file {'/etc/php5/conf.d/zz-parrot.ini':
#    source => ['/vagrant_parrot_config/php/parrot-local.ini',
#               '/vagrant_parrot_config/php/parrot-local.ini.template'],
#    require => Package['php5'],
#    owner => 'root',
#    group => 'root',
#    notify => Service['apache2'],
#  }
#
#  case $parrot_php_version {
#    '5.5': {
#
#      file {'/etc/php5/fpm/conf.d/80-parrot.ini':
#        ensure => 'link',
#        target => '/etc/php5/conf.d/zz-parrot.ini',
#        notify => Service['php5-fpm'],
#        require => File['/etc/php5/conf.d/zz-parrot.ini'],
#      }
#    }
#  }
#
#
#  # Pull in the pear class, which will install uploadprogress for us.
#  class {'pear':
#    require => Package['php5'],
#    notify => Service['apache2'],
#  }
#
# Upload progress is being re-installed every time Puppet runs.
  # We'll need to fix this at some point.
  class {
    '::php::extension::uploadprogress':
    package => 'uploadprogress',
    require => Class['::php::dev'],
    ensure => 'present',
  }
  file { '/etc/php5/fpm/conf.d/20-uploadprogress.ini':
    ensure => 'link',
    target => '../../mods-available/uploadprogress.ini',
    require => Class['::php::extension::uploadprogress'],
    notify => Service['php5-fpm'],
  }

  php::extension { 'xhprof':
    require => Class['::php::dev'],
    ensure   => 'present',
    package  => 'xhprof-0.9.4',
    provider => 'pecl',
  }
  php::config { 'php-extension-xhprof':
    file    => "${php::params::config_root_ini}/xhprof.ini",
    config  => [
      'set ".anon/extension" "xhprof.so"'
    ],
    notify => Service['php5-fpm'],
  }
  file { '/etc/php5/fpm/conf.d/20-xhprof.ini':
    ensure => 'link',
    target => '../../mods-available/xhprof.ini',
    require => Php::Extension['xhprof'],
    notify => Service['php5-fpm'],
  }
#  file {"/tmp/xhprof":
#    ensure  => 'directory',
#    owner   => root,
#    group   => root,
#    mode    => 0777,
#  }
#
  host { 'host_machine.parrot':
    ip => regsubst($vagrant_guest_ip,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\1.\2.\3.1'),
    comment => 'Added automatically by Parrot',
    ensure => 'present',
  }

  # Add composer with autoupdate.
  class { ['php::composer', 'php::composer::auto_update']:}

}
