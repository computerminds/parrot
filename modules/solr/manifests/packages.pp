class solr::packages {
  package { "tomcat6":
    ensure => present,
  }

  package { "java":
    ensure => present,
    name => $operatingsystem ? {
      'Centos' => $operatingsystemrelease ? {
        '6.0' => "java-1.6.0-openjdk.$hardwaremodel",
         '*' => 'openjdk-6-jre',
      },
      'Debian' => 'openjdk-6-jre-headless',
      'Ubuntu' => 'openjdk-6-jre-headless',
    },
  }
}
