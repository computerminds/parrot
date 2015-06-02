class drush (
  $drush_branch = '6.x',
  $git_repo = 'https://github.com/drush-ops/drush.git'
) {

    include parrot_php::composer

    # Check that git is installed.
    if ! defined(Package['git']) {
      package { 'git':
        ensure => present,
        before => Exec['clone_drush'],
      }
    }

    case $drush_branch {
      # 6.x branch, fine for most Drupal 7 uses.
      '6.x': {
        exec { 'clone_drush':
          path => "/bin:/usr/bin",
          cwd => "/opt",
          command => "git clone -b $drush_branch $git_repo",
          creates => "/opt/drush",
          require => [Package["git-core"]],
        }

        # Complete Drush install
        # Run once to download console table etc.
        exec { "drush_first_run":
          command => "/opt/drush/drush",
          require => [Exec['clone_drush']],
        }

      }
      # 7.x branch, required for Drupal 8
      '7.x', default: {
        exec { 'clone_drush':
          path => "/bin:/usr/bin",
          cwd => "/opt",
          command => "git clone -b $drush_branch $git_repo",
          creates => "/opt/drush",
          require => [Class['parrot_php::composer'], Package["git-core"]],
          notify => Exec['composer_drush_install'],
        }

        # Complete Drush install by running "composer install" in the Drush directory.
        exec { 'composer_drush_install':
          command => '/usr/local/bin/composer install',
          environment => [ "COMPOSER_HOME=/opt/drush" ],
          cwd => '/opt/drush',
          refreshonly => true,
          require => [Exec['clone_drush']],
        }

      }
    }

  # Symlink Drush
  file { 'symlink_drush':
    ensure => link,
    path => '/usr/bin/drush',
    target => '/opt/drush/drush',
    require => Exec['clone_drush'],
  }

}
