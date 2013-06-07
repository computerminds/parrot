class http_stack::varnish {

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
      source => '/vagrant_parrot_config/varnish/default.vcl',
      require => Package['varnish'],
      owner => 'root',
      group => 'root',
    }

    file { "/etc/default/varnish":
      source => 'puppet:///modules/http_stack/varnish/defaults',
      require => Package['varnish'],
      owner => 'root',
      group => 'root',
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
