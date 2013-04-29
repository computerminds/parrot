class preseed_package::requirements {
  file {'/var/local/preseed':
    ensure => 'directory',
  }
}