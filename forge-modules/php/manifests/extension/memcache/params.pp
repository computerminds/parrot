# == Class: php::extension::memcache::params
#
# Defaults file for the Memcache PHP extension
#
# === Parameters
#
# No parameters
#
# === Variables
#
# [*ensure*]
#   The version of the package to install
#   Could be "latest", "installed" or a pinned version
#   This matches "ensure" from Package
#
# [*package*]
#   The package name in your provider
#
# [*provider*]
#   The provider used to install the package
#
# [*inifile*]
#   The path to the extension ini file
#
# [*settings*]
#   Hash with 'set' nested hash of key => value
#   set changes to agues when applied to *inifile*
#
# === Examples
#
# No examples
#
# === Authors
#
# Christian "Jippi" Winther <jippignu@gmail.com>
# Nathan Sullivan <nmsullivan@gmail.com>
#
# === Copyright
#
# Copyright 2012-2015 Christian "Jippi" Winther, unless otherwise noted.
#
class php::extension::memcache::params {

  $ensure   = $php::params::ensure
  $provider = undef
  $inifile  = "${php::params::config_root_ini}/memcache.ini"
  $settings = [
    'set ".anon/extension" "memcache.so"'
  ]
  if (versioncmp($php::params::major_version, "7") >= 0) {
    # Leave alone as there's no php7.0-imagick yet...so we'll have to phpize
    $package  = 'php-memcache'
  } else {
    $package  = 'php5-memcache'
  }
}
