class parrot_drush {
  # Install/Update drush
  exec {'Install/Update drush' :
    command => "/usr/bin/curl -L 'https://github.com/drush-ops/drush/releases/download/8.1.2/drush.phar' > /usr/local/bin/drush",
    creates => "/usr/local/bin/drush",
  }

  file {"/usr/local/bin/drush" :
    require => Exec['Install/Update drush'],
    mode => 0555,
  }
}
