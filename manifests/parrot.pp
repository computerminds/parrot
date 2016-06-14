node default {
  anchor {"parrot:begin": }
  ->
  class { parrot_repos: }
  ->
  class { parrot_php:  }
  ->
  anchor {"parrot:end": }

  class { solr_server:  }
  class { parrot_mysql: }

  class { 'ohmyzsh': }
  ohmyzsh::install { ['root', 'vagrant']: }
  ohmyzsh::theme { ['root', 'vagrant']: theme => 'steeef' } # specific theme
  class { sudoers: }
  case $parrot_varnish_enabled {
    'true', true: {
      class { 'http_stack::with_varnish':
        require => Class['parrot_repos'],
      }
    }
    default: {
      class { 'http_stack::without_varnish':
        require => Class['parrot_repos'],
      }
    }
  }
  # class { parrot_drush: }
  class { mailcollect: }

  package { 'vim': }
  package { 'vim-puppet': }
  package { 'curl': }

  # Ensure ntp is installed.
  class { '::ntp': }



}
