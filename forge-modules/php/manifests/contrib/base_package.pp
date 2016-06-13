# == Class: php::contrib::base_package
#
# Install php base package.
#
# === Parameters
#
# [*ensure*]
#   The ensure of the package to install
#   Could be "latest", "installed" or a pinned version
#
# [*provider*]
#   The provider used to install the package
#   Could be "pecl", "apt", "dpkg" or any other OS package provider
#
# === Variables
#
# No variables
#
# === Examples
#
#
#
# === Authors
#
#
#
# === Copyright
#
#
#
define php::contrib::base_package(
  $ensure,
  $provider = undef
) {

  $base_package_name = "php${php::params::major_version}-common"
  if !defined(Package[$base_package_name]) {
    package { $base_package_name:
      ensure   => $ensure,
      provider => $provider
    }
  }

}
