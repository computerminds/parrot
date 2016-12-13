node default {
  anchor {"parrot:begin": }
  ->
  class { parrot_repos: }
  ->
  anchor {"parrot:repos": }
  ->
  class { parrot_mysql: }
  ->
  class { solr_server: }
  ->
  anchor {"parrot:http_stack": }
  ->
  class { parrot_php: }
  ->
  class { parrot_drush: }
  ->
  anchor {"parrot:end": }

  class { 'ohmyzsh': }
  ohmyzsh::install { ['root', 'vagrant']: }
  ohmyzsh::theme { ['root', 'vagrant']: theme => 'steeef' } # specific theme
  class { sudoers: }
  case $parrot_varnish_enabled {
    'true', true: {
      class { 'http_stack::with_varnish':
        require => Anchor["parrot:http_stack"],
      }
    }
    default: {
      class { 'http_stack::without_varnish':
        require => Anchor["parrot:http_stack"],
      }
    }
  }
  class { mailcollect:
    require => Anchor["parrot:repos"],
  }

  package { ['vim', 'vim-puppet', 'curl']:
    require => Anchor["parrot:repos"],
  }

  # Ensure ntp is installed.
  class { '::ntp':
    require => Anchor["parrot:repos"],
  }

  # Install gulp with nodejs if required.
  case $parrot_gulp_enabled {
    'true', true: {
      # Add sources for nodejs binaries and install nodejs package.
      # See: https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
      exec { 'nodejs_sources' :
        command => 'curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -',
        path => '/usr/bin',
        creates => '/etc/apt/sources.list.d/nodesource.list',
      }
      package { 'nodejs':
        ensure => installed,
        require => Exec['nodejs_sources'],
      }
      exec { 'install_gulp' :
        command => 'npm install --global gulp-cli',
        path => '/usr/bin',
        creates => '/usr/bin/gulp',
        require => Package['nodejs'],
      }
    }
  }

}
