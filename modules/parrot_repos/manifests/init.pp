class parrot_repos {

  # Add a repo for Varnish.
  apt::source { 'varnish':
      location   => 'http://repo.varnish-cache.org/ubuntu/',
      repos      => 'varnish-3.0',
      release    => 'trusty',
      key        => {
        "id"     => "C4DEFFEB",
        "source" => "http://repo.varnish-cache.org/debian/GPG-key.txt",
      },
  }
}
