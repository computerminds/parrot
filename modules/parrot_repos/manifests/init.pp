class parrot_repos {

  include apt

  # Add a repo for Varnish.
  apt::source { 'varnish':
      location   => 'http://repo.varnish-cache.org/ubuntu/',
      repos      => 'varnish-3.0',
      release    => 'trusty',
      key        => {
        "id"     => "E98C6BBBA1CBC5C3EB2DF21C60E7C096C4DEFFEB",
        "source" => "http://repo.varnish-cache.org/debian/GPG-key.txt",
      },
  }
  # Add a repo for Apache 2.4.8+.
  apt::ppa { 'ppa:ondrej/apache2':
    package_manage => true,
  }
  apt::ppa { 'ppa:ondrej/php':
    package_manage => true,
  }

}
