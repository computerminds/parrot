class solr::config {
  $tomcat_user = $operatingsystem ? {
    /RedHat|CentOS/ => "tomcat",
    /Debian|Ubuntu/ => "tomcat6",
  }

  $tomcat_conf_file = $operatingsystem ? {
    /RedHat|CentOS/ => "/etc/sysconfig/tomcat6",
    /Debian|Ubuntu/ => "/etc/default/tomcat6",
  }

  file { "solr home dir":
    path => $solr::home_dir,
    ensure => directory,
    recurse => true,
  }

  file { "solr data dir":
    path => $solr::data_dir,
    ensure => directory,
    recurse => true,
    owner => $tomcat_user,
    group => $tomcat_user,
  }

  augeas { "solr config":
    changes => [
      "set /files${tomcat_conf_file}/JAVA_OPTS '\"-Djava.awt.headless=true -Dsolr.solr.home=${solr::home_dir} -Dsolr.data.dir=${solr::data_dir} -Xmx128m -XX:+UseConcMarkSweepGC\"'",
    ],
    require => [File["solr data dir"], File["solr home dir"]],
    notify => Service["tomcat6"],
  }

  file { "/etc/tomcat6/server.xml":
    ensure => present,
    source => "puppet:///modules/solr/etc/tomcat6/server.xml",
    notify => Service["tomcat6"],
    owner => $tomcat_user,
    group => $tomcat_user,
  }
}
