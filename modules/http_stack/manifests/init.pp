class http_stack(
  $apache_http_port  = 8080,
  $apache_https_port = 443,
  $varnish_port      = 80
) {

  # We're going to install Varnish on Port 80 by default.
  class { http_stack::varnish:
    varnish_port => $varnish_port,
    backend_port => $apache_http_port,
  }

  # And then apache on port 8080 by default.
  class { http_stack::apache:
    before => Class['http_stack::varnish'],
    apache_http_port => $apache_http_port,
  }

}
