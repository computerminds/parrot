class parrot_repos {
  anchor {'parrot_repos::begin': }
  ->
  class { 'apt':
    update => {
      frequency => 'daily',
    },
  }
  ->
  # Remove the old varnish repo.
  apt::source { 'varnish':
      location   => 'http://repo.varnish-cache.org/ubuntu/',
      repos      => 'varnish-3.0',
      release    => 'trusty',
      ensure => 'absent',
  }
  apt::source { 'varnish30':
      location   => 'https://packagecloud.io/varnishcache/varnish30/ubuntu/',
      repos      => 'main',
      release    => 'trusty',
      key        => {
        'id' => '246BE381150865E2DC8C6B01FC1318ACEE2C594C',
        'source' => 'https://packagecloud.io/varnishcache/varnish30/gpgkey',
      },
  }
  ->
  # Add a repo for Apache 2.4.8+.
  apt::ppa { 'ppa:ondrej/apache2':
    package_manage => true,
  }
  ->
  apt::ppa { 'ppa:ondrej/php':
    package_manage => true,
  }
  ->
  anchor {'parrot_repos::end': }
}
