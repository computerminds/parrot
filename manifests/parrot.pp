node default {

  class { apt: }
  class { parrot_repos: }
  class { solr_server:  }
  class { parrot_mysql:  }
  class { parrot_php:  }
  class { oh_my_zsh:  }
  class { sudoers: }
  case $parrot_varnish_enabled {
    'true', true: {
      class { 'http_stack::with_varnish': }
    }
    default: {
      class { 'http_stack::without_varnish': }
    }
  }
  class { mailcollect: }

  package { 'vim': }
  package { 'vim-puppet': }
  package { 'curl': }

  # Ensure ntp is installed.
  class { ntp:
    ensure     => running,
    autoupdate => true,
  }

  # Install nodejs and associated node packages
  class { 'nodejs':
    repo_url_suffix => 'node_0.12',
  }
  package { 'bower':
    ensure   => present,
    provider => 'npm',
    require  => Class['nodejs'],
  }
  package { 'gulp':
    ensure   => present,
    provider => 'npm',
    require  => Class['nodejs'],
  }
  package { 'grunt-cli':
    ensure   => present,
    provider => 'npm',
    require  => Class['nodejs'],
  }
  
  # Optionally install drush
  case $parrot_drush_installed {
    'true', true: {
      class {'drush':
        drush_branch => $parrot_drush_branch,
      }
    }
  }

}
