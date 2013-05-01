class http_stack {
   # We're going to install Varnish on Port 80
   class { http_stack::varnish: }

   # And then apache on port 8080
   class { http_stack::apache:
     require => Class['http_stack::varnish'],
   }

}