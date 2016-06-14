define parrot_php::config (
  $p_php_version = $name,
  $php_fpm_package = "php$name-fpm",
  $php_fpm_package = "php$name-fpm",
  $php_cli_package = "php$name-cli",
)
{
  # Set up php.ini.
  file {"/etc/php/$p_php_version/fpm/conf.d/200-parrot.ini":
    source => '/vagrant_parrot_config/php/parrot-base.ini',
    require => Package[$php_fpm_package],
    owner => 'root',
    group => 'root',
    notify => Service[$php_fpm_package],
  }

  # Set up php.ini.
  file {"/etc/php/$p_php_version/cli/conf.d/200-parrot.ini":
    source => '/vagrant_parrot_config/php/parrot-base.ini',
    require => Package[$php_cli_package],
    owner => 'root',
    group => 'root',
  }

  # Set up php.ini.
  file {"/etc/php/$p_php_version/fpm/conf.d/300-parrot-local.ini":
    source => ['/vagrant_parrot_config/php/parrot-local.ini',
               '/vagrant_parrot_config/php/parrot-local.ini.template'],
    require => Package[$php_fpm_package],
    owner => 'root',
    group => 'root',
    notify => Service[$php_fpm_package],
  }
  file {"/etc/php/$p_php_version/cli/conf.d/300-parrot-local.ini":
    source => ['/vagrant_parrot_config/php/parrot-local.ini',
               '/vagrant_parrot_config/php/parrot-local.ini.template'],
    require => Package[$php_cli_package],
    owner => 'root',
    group => 'root',
  }
}
