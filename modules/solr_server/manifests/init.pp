# Pergola class to install Solr and Tomcat.
class solr_server {

  $running = 'running'

  class {'solr':
    backend => 'tomcat',
    home_dir => '/opt/solr/home',
    data_dir => '/opt/solr/data',
    require => File['/opt/solr'],
    ensure => $running,
  }

  file {'/opt/solr':
    ensure => 'directory',
  }

  # Find the cores.
  $core_names_string = generate('/usr/bin/find', '/vagrant_parrot_config/solr/' , '-type', 'd', '-printf', '%f\0', '-maxdepth', '1', '-mindepth', '1')
  $core_names = split($core_names_string, '\0')

  # Add the global Solr config to inform Solr of our cores.
  file { "solr home dir/solr.xml":
    path => "$solr::home_dir/solr.xml",
    content => template('solr_server/solr.xml.erb'),
    require => File['solr home dir'],
    notify => Service["tomcat6"],
    mode => 0644,
  }

  # Set up the cores
  define solrCoresResource {
    solr_server::solrcore { $name:
      solrconfig => "/vagrant_parrot_config/solr/$name",
    }
  }
  # Puppet magically turns our array into lots of resources.
  solrCoresResource { $core_names: }

}
