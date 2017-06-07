define http_stack::apache::site () {

  # Special handling for a 'webroot' subdirectory.
  # We pretend like it's the root.
  $f = "/vagrant_sites/$name/webroot"
  $_exists = inline_template("<%= File.exists?('$f') %>")
  case $_exists {
      "true": { $webroot_subdir = "/webroot$apache_vhost_webroot_subdir" }
      "false": { $webroot_subdir = $apache_vhost_webroot_subdir }
  }
  # @TODO: replace the above with hiera.

  # Test for PHP 7.x
  $f2 = "/vagrant_sites/$name/.parrot-php7"
  $_exists2 = inline_template("<%= File.exists?('$f2') %>")
  case $_exists2 {
    "true": { $fpm_port = "9997" } # PHP 7.1
    "false": {

      # Test for PHP 7.1
      $f3 = "/vagrant_sites/$name/.parrot-php7.1"
      $_exists3 = inline_template("<%= File.exists?('$f3') %>")
      case $_exists3 {
        "true": { $fpm_port = "9997" } # PHP 7.1
        "false": {

          # Test for PHP 7.0
          $f4 = "/vagrant_sites/$name/.parrot-php7.0"
          $_exists4 = inline_template("<%= File.exists?('$f4') %>")
          case $_exists4 {
            "true": { $fpm_port = "9998" } # PHP 7.0
            "false": { $fpm_port = "9999" } # PHP 5.6
          }
        }
      }
    }
  }
  # @TODO: replace the above with hiera.

  # The file in sites-available.
  file {"/etc/apache2/sites-available/$name":
    ensure => 'file',
    content => template('http_stack/apache/vhost.erb'),
    notify => Service['apache2'],
    require => Package['apache2'],
    owner => 'root',
    group => 'root',
  }
  # The symlink in sites-enabled.
  file {"/etc/apache2/sites-enabled/20-$name.conf":
    ensure => 'link',
    target => "/etc/apache2/sites-available/$name",
    notify => Service['apache2'],
    require => Package['apache2'],
    owner => 'root',
    group => 'root',
  }

  # Add this virtual host to the hosts file
  host { $name:
    ip => '127.0.0.1',
    comment => 'Added automatically by Parrot',
    ensure => 'present',
  }

  # Add an SSL cert just for this host.
  exec { "ssl-cert-$name":
    command => "/usr/bin/openssl req -new -x509 -days 3650 -sha1 -newkey rsa:1024 -nodes -keyout $name.key -out $name.crt -subj '/O=Company/OU=Department/CN=$name'",
    require => File['/etc/apache2/ssl.d'],
    cwd => '/etc/apache2/ssl.d',
    creates => "/etc/apache2/ssl.d/$name.key",
    user => 'root',
    group => 'root',
  }

}
