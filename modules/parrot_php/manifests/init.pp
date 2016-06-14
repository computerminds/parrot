class parrot_php (
  $fpm_user_uid  = $vagrant_host_user_uid,
  $fpm_user_gid  = $vagrant_host_user_gid,
)
{

  $php_packages = [
    'php5.6',
    'php5.6-fpm',
    'php5.6-cli',
    'php5.6-dev',
    'php5.6-opcache',
    'php5.6-gd',
    'php5.6-curl',
    'php5.6-xmlrpc',
    'php5.6-mysql',
    'php5.6-common',
    'php5.6-xdebug',
    'php5.6-xhprof',

    'php7.0',
    'php7.0-fpm',
    'php7.0-cli',
    'php7.0-dev',
    'php7.0-opcache',
    'php7.0-gd',
    'php7.0-curl',
    'php7.0-xmlrpc',
    'php7.0-mysql',
    'php7.0-common',
    'php7.0-xdebug',
    # 'php7.0-xhprof',

    'php-uploadprogress',

  ]

  # Extensions:
  # - GD
  # - curl
  # - xmlrpc
  # - mysql
  # - mysqli
  # - xdebug
  # - xhprof
  # - uploadprogress

  package {$php_packages:
    ensure => latest,
  }
  ->
  # Fix a bug in Ubuntu https://bugs.launchpad.net/ubuntu/+source/php5/+bug/1242376
  file {['/etc/init/php5.6-fpm.override', '/etc/init/php7.0-fpm.override']:
    ensure => 'file',
    owner => 'root',
    group => 'root',
    content => inline_template("reload signal SIGUSR2", "\n"),
  }
  # ->
  service { 'php7.0-fpm':
    ensure    => 'running',
    enable    => true,
    restart   => "service php7.0-fpm reload",
    hasstatus => true,
  }
  service { 'php5.6-fpm':
    ensure    => 'running',
    enable    => true,
    restart   => "service php5.6-fpm reload",
    hasstatus => true,
  }
  # We need a user to exist that will run our PHP.
  user {'host_user':
    ensure => 'present',
    uid => $fpm_user_uid,
    gid => $fpm_user_gid,
  }
  # ->
  parrot_php::fpm::pool { 'www-7.0':
    listen => '127.0.0.1:9998',
    pm_max_children => 10,
    pm_start_servers => 2,
    pm_max_requests => 100,
    chdir => '/',
    pm_min_spare_servers => 1,
    pm_max_spare_servers => 4,
    user => 'host_user',
    group => $fpm_user_gid,

    pool => 'www',
    php_version => '7.0',
    php_fpm_package => 'php7.0-fpm',
    php_fpm_service => 'php7.0-fpm',
  }
  parrot_php::fpm::pool { 'www-5.6':
    listen => '127.0.0.1:9999',
    pm_max_children => 10,
    pm_start_servers => 2,
    pm_max_requests => 100,
    chdir => '/',
    pm_min_spare_servers => 1,
    pm_max_spare_servers => 4,
    user => 'host_user',
    group => $fpm_user_gid,

    pool => 'www',
    php_version => '5.6',
    php_fpm_package => 'php5.6-fpm',
    php_fpm_service => 'php5.6-fpm',
  }

  package {['libapache2-mod-php5', 'libapache2-mod-php7.0', 'libapache2-mod-php5.6']:
    ensure => 'absent',
  }

  # include '::php'
  #
  # $php_packages = [
  #  'php5-cgi',
  #  'php5-sqlite',
  #  'php5-xmlrpc',
  # ]
  #
  # class { [
  #   '::php::extension::gd',
  #   '::php::pear',
  #
  # ]: } ->
  #
  # php::fpm::config { 'parrot-settings':
  #   config => [
  #     "set PHP/memory_limit 256M",
  #     "set PHP/max_execution_time 300",
  #     'set PHP/error_reporting "E_ALL | E_STRICT"',
  #     "set PHP/display_errors On",
  #     "set PHP/html_errors On",
  #     "set PHP/display_startup_errors On",
  #     "set PHP/log_errors On",
  #     "set PHP/error_log syslog",
  #     "set PHP/post_max_size 8M",
  #     "set PHP/realpath_cache_size 1M",
  #     "set PHP/realpath_cache_ttl 300",
  #   ],
  # }
  #
  # class { '::php::extension::opcache':
  #   settings => [
  #     "set .anon/opcache.memory_consumption 256",
  #     "set .anon/opcache.enable 1",
  #   ],
  # }
  #
  # class { '::php::extension::xdebug':
  #   settings => [
  #     "set XDebug/xdebug.max_nesting_level 256",
  #     "set XDebug/xdebug.remote_enable 1",
  #     "set XDebug/xdebug.remote_handler dbgp",
  #     "set XDebug/xdebug.remote_host host_machine.parrot",
  #     "set XDebug/xdebug.remote_port 9000",
  #   ],
  # }
  #
  # php::fpm::config { 'xdebug-parrot-settings-phpstorm':
  #   setting => 'xdebug.file_link_format',
  #   value   => '"javascript:var rq = new XMLHttpRequest(); rq.open(\'GET\', \'http://localhost:8091?message=%f:%l\', true); rq.send(null);"',
  #   file    => "${php::params::config_root_ini}/xdebug.ini",
  #   section => 'XDebug',
  # }
  #
  # $log_level = 'debug'
  # $emergency_restart_threshold = '0'
  # $emergency_restart_interval  = '0'
  # $process_control_timeout     = '0'
  #
  # # Manually install the xmlrpc extension.
  # php::extension { 'xmlrpc':
  #   ensure   => $::php::params::ensure,
  #   package  => 'php5-xmlrpc',
  #   provider => undef,
  # }
  #
  # php::fpm::pool { 'www':
  #   listen => '127.0.0.1:9999',
  #   pm_max_children => 10,
  #   pm_start_servers => 2,
  #   pm_max_requests => 100,
  #   chdir => '/',
  #   pm_min_spare_servers => 1,
  #   pm_max_spare_servers => 4,
  #   user => 'host_user',
  #   group => $fpm_user_gid,
  # }
  #
  #
  # # We need a user to exist that will run our PHP.
  # user {'host_user':
  #   ensure => 'present',
  #   uid => $fpm_user_uid,
  #   gid => $fpm_user_gid,
  # }
  #
  #
  # package { 'graphviz': }
  #
  # # Install extensions
  # Php::Extension <| |>
  #   # Configure extensions
  #   -> Php::Config <| |>
  #
  # # Restart FPM if an extension is installed or configured.
  # Php::Extension <| |> ~> Service['php5-fpm']
  # Php::Config <| |>    ~> Service['php5-fpm']
  #
  # # Upload progress is being re-installed every time Puppet runs.
  # # We'll need to fix this at some point.
  # class {
  #   '::php::extension::uploadprogress':
  #   package => 'uploadprogress',
  #   require => Class['::php::dev'],
  #   ensure => 'present',
  # }
  # file { '/etc/php5/fpm/conf.d/20-uploadprogress.ini':
  #   ensure => 'link',
  #   target => '../../mods-available/uploadprogress.ini',
  #   require => Class['::php::extension::uploadprogress'],
  #   notify => Service['php5-fpm'],
  # }
  #
  # php::extension { 'xhprof':
  #   require => Class['::php::dev'],
  #   ensure   => 'present',
  #   package  => 'xhprof-0.9.4',
  #   provider => 'pecl',
  # }
  # php::config { 'php-extension-xhprof':
  #   file    => "${php::params::config_root_ini}/xhprof.ini",
  #   config  => [
  #     'set ".anon/extension" "xhprof.so"'
  #   ],
  #   notify => Service['php5-fpm'],
  # }
  # file { '/etc/php5/fpm/conf.d/20-xhprof.ini':
  #   ensure => 'link',
  #   target => '../../mods-available/xhprof.ini',
  #   require => Php::Extension['xhprof'],
  #   notify => Service['php5-fpm'],
  # }
  #
  host { 'host_machine.parrot':
   ip => regsubst($vagrant_guest_ip,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\1.\2.\3.1'),
   comment => 'Added automatically by Parrot',
   ensure => 'present',
  }
  #
  # # Add composer with autoupdate.
  # class { ['php::composer', 'php::composer::auto_update']:}

}
