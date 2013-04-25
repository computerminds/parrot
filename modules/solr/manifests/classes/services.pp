class solr::services {
  service { "tomcat6":
      ensure => $solr::ensure,
      enable => "true",
    }
}
