class parrot_php::composer {

  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present,
      before => Exec['composer_install'],
    }
  }

  case $lsbdistcodename {
    'trusty': {
      # This may be needed on 14.04, but not 12.04?
      file_line { 'suhosin.executor.include.whitelist = phar':
        path => '/etc/php5/cli/conf.d/suhosin.ini',
        line => 'suhosin.executor.include.whitelist = phar',
      }

      exec { 'composer_install':
        command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
        creates => '/usr/local/bin/composer',
        require => [
          File_line['suhosin.executor.include.whitelist = phar'],
          Class['parrot_php'],
        ],
      }

    }
    'precise': {

      exec { 'composer_install':
        command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
        creates => '/usr/local/bin/composer',
        path => "/bin:/usr/bin",
        cwd => "/tmp",
        require => [
          Class['parrot_php'],
        ],
      }

    }

  }

}