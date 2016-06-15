class http_stack(
  $apache_http_port  = 8080,
  $apache_https_port = 443,
  $varnish_port      = 80
) {

  # Install varnish on the specified port.
  class { http_stack::varnish:
    varnish_port => $varnish_port,
    backend_port => $apache_http_port,
  }

  # Install apache on the specified port.
  class { http_stack::apache:
    before => Class['http_stack::varnish'],
    apache_http_port => $apache_http_port,
  }

}
