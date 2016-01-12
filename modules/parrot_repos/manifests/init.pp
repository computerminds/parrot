class parrot_repos {

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

  #Install PHP repos
  case $parrot_php_version {
    '5.5': {

    }
    '5.6': {
      apt::source { 'php5-5.6':
        location   => 'http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu/',
        # TODO: this needs to be the full key.
        key        => "E5267A6C",
      }
    }
    default: {
      # Todo: Notify that we don't support this version.
    }
  }
}
