# == Class: php::params
#
# PHP params class
#
# Configuration class for php module
#
# === Parameters
#
# No parameters
#
# === Variables
#
# [*ensure*]
#   The PHP ensure of PHP to install
#
# === Examples
#
#  include php::dev
#
# === Authors
#
# Christian "Jippi" Winther <jippignu@gmail.com>
#
# === Copyright
#
# Copyright 2012-2015 Christian "Jippi" Winther, unless otherwise noted.
#
class php::params {
  $major_version = hiera("php::params::php_version", "5")
  $ensure = 'installed'
  if (versioncmp($major_version, '7') >= 0) {
    $config_root = "/etc/php/${major_version}"
  } else {
    $config_root = "/etc/php${major_version}"
  }

  if $::php_version == '' or versioncmp($::php_version, '5.4') >= 0 {
    $config_root_ini = "${::php::params::config_root}/mods-available"
  } else {
    $config_root_ini = "${::php::params::config_root}/conf.d"
  }

  $augeas_contrib_dir = '/usr/share/augeas/lenses/contrib'
}
