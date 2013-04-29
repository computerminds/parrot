# We basically just install Puppet so that subsequent runs can rely on it being installed.
node default {

  # Run apt-get update when anything beneath /etc/apt/ changes
  exec { "apt-update":
    command => "/usr/bin/apt-get update",
    onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
  }

  Exec["apt-update"] -> Package <| |>

  package { "puppet":
    ensure => latest,
  }

}
