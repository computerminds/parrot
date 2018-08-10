define parrot_drush::components::php::drush_alias (
  $root,
  $ensure = 'present',
  $uri = $name,
  $php_executable = undef,
  $protocol = '',
)
{

  # Create home directories for the users that will be using Drush.
  file { '/home/vagrant/.drush':
    ensure => 'directory',
    owner => 'vagrant',
    group => 'vagrant',
  }

  file {"/home/vagrant/.drush/$name.aliases.drushrc.php":
    ensure => $ensure,
    owner => 'vagrant',
    group => 'vagrant',
    content => template('parrot_drush/php/drush_alias.erb'),
    require => File['/home/vagrant/.drush'],
  }
}
