class solr::files {

  exec { "cache_solr":
    cwd => "/vagrant_parrot_config/solr",
    command => "/usr/bin/wget -c http://archive.apache.org/dist/lucene/solr/4.7.1/solr-4.7.1.tgz",
    creates => ["/vagrant_parrot_config/solr/solr-4.7.1.tgz", "/var/lib/tomcat6/webapps/solr.war"],
    timeout => 0,
  }

  exec { "download_solr":
    cwd => "/tmp",
    command => "/bin/cp /vagrant_parrot_config/solr/solr-4.7.1.tgz /tmp/",
    creates => ["/tmp/solr-4.7.1.tgz", "/var/lib/tomcat6/webapps/solr.war"],
    require => Exec["cache_solr"],
  }

  exec { "unpack_solr":
    cwd => "/tmp",
    command => "/bin/tar xzf /tmp/solr-4.7.1.tgz",
    creates => ["/tmp/solr-4.7.1", "/var/lib/tomcat6/webapps/solr.war"],
    require => Exec["download_solr"],
  }

  exec { "deploy_solr":
    cwd => "/tmp",
    command => "/bin/cp /tmp/solr-4.7.1/dist/solr-4.7.1.war /var/lib/tomcat6/webapps/solr.war",
    creates => "/var/lib/tomcat6/webapps/solr.war",
    require => Exec["unpack_solr"],
  }

  exec { "copy_solr_libs":
    cwd => "/tmp",
    command => "/bin/cp /tmp/solr-4.7.1/example/lib/ext/* /usr/share/tomcat6/lib/",
    creates => "/usr/share/tomcat6/lib/slf4j-log4j12-1.6.6.jar",
    require => Exec["unpack_solr"],
  }

  #exec { "remove_tar":
    #cwd => "/tmp",
    #command => "/bin/rm /tmp/apache-solr-4.2.1.tgz",
    #require => [ Exec["download_solr"], Exec["unpack_solr"] ],
  #}
}
