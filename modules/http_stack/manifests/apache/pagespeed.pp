class http_stack::apache::pagespeed (
	$ensure = 'latest',
) {
  # Repo
  apt::source { 'mod-pagespeed':
    location   => 'http://dl.google.com/linux/mod-pagespeed/deb/',
    repos => 'main',
    release => 'stable',
    include_src => false,
    key => 'C07CB649',
    key_source => 'https://dl-ssl.google.com/linux/linux_signing_key.pub',
   }

  # Package
  package { 'mod-pagespeed-stable':
    require => [Apt::Source['mod-pagespeed'], Package['apache2']],
    ensure => $ensure,
  }

  # Config
  file {'/etc/apache2/mods-available/pagespeed.conf':
    source => ['/vagrant_parrot_config/pagespeed/pagespeed.conf',
               '/vagrant_parrot_config/pagespeed/pagespeed.conf.template'],
    require => Package['mod-pagespeed-stable'],
    owner => 'root',
    group => 'root',
    notify => Service['apache2'],
  }
}