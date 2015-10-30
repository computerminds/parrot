class parrot_drush {

  # Make sure we have a place to put our composer items.
  file {'/composer':
    owner => 'vagrant',
    group => 'vagrant',
    ensure => 'directory',
  }

  # Install/Update drush
  exec {'Install/Update drush' :
    command     => "/usr/local/bin/composer global require $parrot_drush_version",
    user        => 'vagrant',
    require     => Class['php::composer'],
    environment => 'COMPOSER_HOME=/composer',
  }

  # Make drush executional.
  # TODO A better solution would be to modify the .bashrc file instead of
  # making a symlink for the drush bin.
  file { '/usr/local/bin/drush':
     ensure => 'link',
     target => '/composer/vendor/drush/drush/drush.php',
  }

}
