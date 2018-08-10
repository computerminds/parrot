define parrot_drush::components::php::drush_alias (
  $root,
  $ensure = 'present',
  $uri = $name,
  $php_executable = undef,
  $protocol = '',
)
{

  file {"/home/vagrant/.drush/$name.aliases.drushrc.php":
    ensure => $ensure,
    owner => 'vagrant',
    group => 'vagrant',
    content => template('parrot_drush/php/drush_alias.erb'),
    require => File['/home/vagrant/.drush'],
  }
}
