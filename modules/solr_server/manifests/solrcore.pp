define solr_server::solrcore (
  $core_name = $name,
  $solrconfig
) {

  file { "solr home dir/$core_name":
    path => "$solr::home_dir/$core_name",
    ensure => 'directory',
    require => [ File['solr home dir', "solr home dir/solr.xml"], Class['solr']],
  }

  file { "solr home dir/$core_name/conf":
    path => "$solr::home_dir/$core_name/conf",
    ensure => 'directory',
    require => File["solr home dir/$core_name"],
    notify => Service["tomcat6"],
    source => $solrconfig,
    recurse => true,
  }

  file { "solr home dir/$core_name/data":
    path => "$solr::home_dir/$core_name/data",
    require => File['solr home dir'],
    ensure => directory,
    recurse => true,
    owner => $solr::config::tomcat_user,
    group => $solr::config::tomcat_user,
    notify => Service["tomcat6"],
  }
}
