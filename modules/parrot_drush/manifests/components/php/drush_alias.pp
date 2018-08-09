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
    owner => 'root',
    group => 'root',
    content => template('parrot_drush/php/drush_alias.erb'),
    #require => File['/home/vagrant/.drush'],
  }

  file {"/root/.drush/$name.aliases.drushrc.php":
    ensure => $ensure,
    owner => 'www-data',
    group => 'www-data',
    content => template('parrot_drush/php/drush_alias.erb'),
    #require => File['/root/.drush'],
  }
}
