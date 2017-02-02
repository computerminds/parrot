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
    'php5.6-mbstring',
    'php5.6-mcrypt',
    'php5.6-xml',
    'php5.6-xmlrpc',
    'php5.6-mysql',
    'php5.6-common',
    'php5.6-soap',
    'php-xhprof',

    'php7.0',
    'php7.0-fpm',
    'php7.0-cli',
    'php7.0-dev',
    'php7.0-opcache',
    'php7.0-gd',
    'php7.0-curl',
    'php7.0-mbstring',
    'php7.0-mcrypt',
    'php7.0-xml',
    'php7.0-xmlrpc',
    'php7.0-mysql',
    'php7.0-common',
    'php7.0-soap',
    'php-xdebug',
    # 'php7.0-xhprof',

    'php-uploadprogress',
    'php-mysql',

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
  ->
  # uploadprogress doesn't get symlinked correctly for some reason.
  file { '/etc/php/5.6/fpm/conf.d/20-uploadprogress.ini':
    ensure => 'link',
    target => '/etc/php/5.6/mods-available/uploadprogress.ini',
    notify => Service['php5.6-fpm'],
  }

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

  parrot_php::config{'5.6': }
  parrot_php::config{'7.0': }

  package { 'graphviz': }

  host { 'host_machine.parrot':
   ip => regsubst($vagrant_guest_ip,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\1.\2.\3.1'),
   comment => 'Added automatically by Parrot',
   ensure => 'present',
  }

}
