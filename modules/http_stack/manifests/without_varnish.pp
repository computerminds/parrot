class http_stack::without_varnish(
  $apache_http_port  = 80,
  $apache_https_port = 443,
  $varnish_port      = 1234
) {

  class { http_stack:
    varnish_port => $varnish_port,
    apache_http_port => $apache_http_port,
    apache_https_port => $apache_https_port,
  }

}
