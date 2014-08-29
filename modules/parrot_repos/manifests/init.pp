class parrot_repos {
  #Install PHP repos
  case $parrot_php_version {
    '5.5': {
      apt::source { 'php5':
        location   => 'http://ppa.launchpad.net/ondrej/php5/ubuntu/',
        key        => "E5267A6C",
      }
      apt::source { 'apache':
        location   => 'http://ppa.launchpad.net/ondrej/apache2/ubuntu/',
        key        => "E5267A6C",
      }
      apt::source { 'php5-oldstable':
        location   => 'http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu/',
        key        => "E5267A6C",
        ensure     => 'absent',
      }
    }
    '5.4': {
      apt::source { 'php5-oldstable':
        location   => 'http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu/',
        key        => "E5267A6C",
      }
    }
    '5.3', default: {
      apt::source { 'php5-oldstable':
        location   => 'http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu/',
        key        => "E5267A6C",
        ensure     => 'absent',
      }
    }
  }

  case $parrot_mysql_version {
    '5.6': {
      apt::source { 'mysql56':
        location   => 'http://ppa.launchpad.net/ondrej/mysql-5.6/ubuntu/',
        key        => "E5267A6C",
      }
    }
    default: {
      
    }
  }

  # Add a repo for Varnish.
  apt::source { 'varnish':
  	  location   => 'http://repo.varnish-cache.org/ubuntu/',
  	  repos      => 'varnish-3.0',
  	  release    => 'precise',
  	  key        => "C4DEFFEB",
      key_source => "http://repo.varnish-cache.org/debian/GPG-key.txt",
  }
}
