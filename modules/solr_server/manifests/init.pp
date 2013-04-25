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

  file { "solr home dir/solr.xml":
    path => "$solr::home_dir/solr.xml",
    content => template('solr_server/solr.xml.erb'),
    require => File['solr home dir'],
    notify => Service["tomcat6"],
  }

  # Set up the cores
  solr_server::solrcore { "drupal-solr-common":
    solrconfig => "/vagrant_solr_config/drupal-solr-common",
  }
}
