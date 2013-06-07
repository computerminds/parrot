class http_stack::varnish(
  $varnish_port,
  $backend_port,
  $admin_port = 6082
) {

  # TODO: We should make the ports for Varnish configurable.

	apt::source { 'varnish':
	  location   => 'http://repo.varnish-cache.org/ubuntu/',
	  repos      => 'varnish-3.0',
	  release    => 'precise',
	  require => Apt::Key['varnish'],
	}

	apt::key { "varnish":
      key        => "C4DEFFEB",
      key_source => "http://repo.varnish-cache.org/debian/GPG-key.txt",
    }

    package { varnish:
       ensure => latest,
       require => Apt::Source['varnish'],
    }

    file { "/etc/varnish/default.vcl":
      require => Package['varnish'],
      owner => 'root',
      group => 'root',
      content => template('http_stack/varnish/default.vcl.erb'),
    }

    file { "/etc/default/varnish":
      require => Package['varnish'],
      owner => 'root',
      group => 'root',
      content => template('http_stack/varnish/defaults.erb'),
    }

    file { "/etc/varnish/secret":
      source => 'puppet:///modules/http_stack/varnish/secret',
      require => Package['varnish'],
      owner => 'root',
      group => 'root',
    }

    service { "varnish":
      enable => true,
      ensure => running,
      hasrestart => true,
      hasstatus => true,
      subscribe => File["/etc/varnish/default.vcl", "/etc/default/varnish", "/etc/varnish/secret"],
    }

    Service['apache2'] ~> Service['varnish']

}
